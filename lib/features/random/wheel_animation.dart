import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class WheelPage extends StatefulWidget {
  late List<String> values;
  WheelPage({super.key, required this.values});

  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> with SingleTickerProviderStateMixin {

  final Random _random = Random();
  final StreamController<int> _controller = StreamController<int>.broadcast();

  late AnimationController _bgController;
  late Animation<Color?> _colorTween;
  late int _lastSelectedIndex = 0;

  bool _init = false;
  bool _run = false;

  int power = 5; // Lực hiện tại
  Timer? timer;
  DateTime? startTime;


  @override
  void initState() {
    super.initState();

    // ✅ phải khởi tạo ở đây
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _colorTween = ColorTween(
      begin: Colors.redAccent,
      end: Colors.yellowAccent,
    ).animate(_bgController);
  }

  void _spin() {
    setState(() {
      _run = true;
      _init = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selected = _random.nextInt(widget.values.length);
      _lastSelectedIndex = selected;
      _bgController.repeat(reverse: true);
      _controller.add(selected);

      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) _bgController.stop();
        setState(() {
          _run = false;
          power = 0;
        });
      });
    });
  }

  void startCharging() {
    startTime = DateTime.now();
    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      final heldTime = DateTime.now().difference(startTime!).inMilliseconds / 1000;

      int increment;
      if (heldTime < 2) {
        increment = 1;
      } else if (heldTime < 5) {
        increment = 1;
      } else {
        increment = 1;
      }

      setState(() {
        power += increment;
        if (power > 20) power = 20;
      });
    });
  }

  void stopCharging() {
    timer?.cancel();
    timer = null;
    _spin();
  }

  @override
  void dispose() {
    _controller.close();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  _colorTween.value ?? Colors.redAccent,
                  Colors.black,
                  Colors.black,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest.shortestSide * 0.8;
                  return Center(
                    child: SizedBox(
                      height: size,
                      width: size,
                      child: FortuneWheel(
                        key: Key(_init.toString()),
                        selected: _controller.stream,
                        rotationCount: power,
                        duration: Duration(seconds: _init ? 10 : 1),
                        curve: Curves.easeOutCubic,
                        onAnimationEnd: () {
                          if(_init){
                            final result = widget.values[_lastSelectedIndex];
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Kết quả"),
                                  content: Text(result),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                            );
                          }
                        },
                        items: [
                          for (var v in widget.values)
                            FortuneItem(
                              child: Text(v,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              style: FortuneItemStyle(
                                color: Colors.primaries[
                                widget.values.indexOf(v) % Colors.primaries.length],
                                borderColor: Colors.white,
                                borderWidth: 3,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if(!_run)...[
              const SizedBox(height: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thanh tiến trình
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: power / 20,
                        backgroundColor: Colors.grey[300],
                        color: Colors.red,
                        minHeight: 20, // cao hơn để dễ nhìn text
                        borderRadius: BorderRadius.circular(16),
                      ),
                      Text(
                        "$power",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Nút bấm
                  GestureDetector(
                    onTapDown: (_) => startCharging(),
                    onTapUp: (_) => stopCharging(),
                    onTapCancel: () => stopCharging(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Quay nào",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ]

          ],
        ),
      ),
    );
  }
}
