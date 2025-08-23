import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'model/BreathingPattern.dart';

class BreathingRun extends StatefulWidget {
  final int mode;
  const BreathingRun({super.key, required this.mode});

  @override
  State<BreathingRun> createState() => _BreathingRunState();
}

class _BreathingRunState extends State<BreathingRun> with SingleTickerProviderStateMixin {
  late BreathingPattern pattern;
  AnimationController? _controller;
  final ScrollController _scrollController = ScrollController();

  // Tốc độ
  static const double pixelPerSecondX = 10;
  static const double pixelPerSecondY = 50;

  final Stopwatch _sw = Stopwatch();
  final List<Offset> _points = [];

  late int total;
  final double _startX = 20;

  int _countdown = 5; // 5 giây
  bool _isCountingDown = true; // đang đếm ngược
  Timer? _countdownTimer;

  String _currentPhaseText = "";
  bool infinite = false;
  @override
  void initState() {
    super.initState();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        _countdownTimer?.cancel();
        _isCountingDown = false; // kết thúc countdown
        _startBreathingAnimation(); // start dot đỏ + path
      }
    });

  }

  void _startBreathingAnimation() {
    pattern = patterns[widget.mode]!;
    total = pattern.inhale +
        pattern.holdAfterInhale +
        pattern.exhale +
        pattern.holdAfterExhale;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: total),
    )..repeat();

    // Dùng Stopwatch để X không reset sau mỗi cycle
    // _sw.start();

    _controller!.addListener(() {
      final elapsed = _controller!.lastElapsedDuration ?? Duration.zero;
      final secondsInCycle = elapsed.inMicroseconds / 1e6;
      final cycles = (elapsed.inSeconds ~/ total); // số cycle đã xong

      final totalSeconds = cycles * total + secondsInCycle; // tổng thời gian
      _tick(totalSeconds);

      final remainingSeconds = 5 * total - totalSeconds; // 5 chu trình
      if (remainingSeconds <= 0 && !infinite) {
        _controller!.stop();
      }
    });

    // _controller.repeat();
  }
  void _tick(double totalSeconds) {

    final screenSize = MediaQuery.of(context).size;
    final baseY = screenSize.height / 2;

    // X luôn tiến về phía trước
    final x = _startX + totalSeconds * pixelPerSecondX;

    // Tính thời gian trong 1 cycle để xác định Y
    final tInCycle = totalSeconds % total;
    double y = _computeYBySpeed(tInCycle, baseY);

    // Chặn Y không vượt khung nhìn
    y = y.clamp(20.0, screenSize.height - 30.0);

    // Thêm điểm mới (mỗi khi x tăng >= 1px để tiết kiệm points)
    setState(() {
      _points.add(Offset(x, y));
      _currentPhaseText = getPhaseWithCountdown(tInCycle);
    });

    // Auto-scroll ngang
    if (_scrollController.hasClients) {
      final screenWidth = screenSize.width;
      final maxVisibleX = _scrollController.offset + screenWidth;
      if (x > maxVisibleX - 50) {
        _scrollController.jumpTo(x - screenWidth + 50);
      }
    }
  }
  // Y theo vận tốc px/s, không map theo screenHeight
  double _computeYBySpeed(double t, double baseY) {
    final inh = pattern.inhale.toDouble();
    final h1  = pattern.holdAfterInhale.toDouble();
    final exh = pattern.exhale.toDouble();
    final h2  = pattern.holdAfterExhale.toDouble();

    if (t <= inh) {
      // inhale: đi lên, mỗi giây -pixelPerSecondY
      return baseY - t * pixelPerSecondY;
    } else if (t <= inh + h1) {
      // hold trên: giữ nguyên mức đã lên
      return baseY - inh * pixelPerSecondY;
    } else if (t <= inh + h1 + exh) {
      // exhale: đi xuống, mỗi giây +pixelPerSecondY
      final te = t - (inh + h1);
      return baseY - inh * pixelPerSecondY + te * pixelPerSecondY;
    } else {
      // hold dưới: giữ mức sau exhale
      return baseY - inh * pixelPerSecondY + exh * pixelPerSecondY;
    }
  }

  String getPhaseWithCountdown(double tInCycle) {
    final inh = pattern.inhale.toDouble();
    final h1  = pattern.holdAfterInhale.toDouble();
    final exh = pattern.exhale.toDouble();
    final h2  = pattern.holdAfterExhale.toDouble();

    if (tInCycle <= inh) {
      final remaining = (inh - tInCycle).ceil();
      return "Hít vào - $remaining s";
    } else if (tInCycle <= inh + h1) {
      final remaining = ((inh + h1) - tInCycle).ceil();
      return "Giữ sau hít - $remaining s";
    } else if (tInCycle <= inh + h1 + exh) {
      final remaining = ((inh + h1 + exh) - tInCycle).ceil();
      return "Thở ra - $remaining s";
    } else {
      final remaining = ((inh + h1 + exh + h2) - tInCycle).ceil();
      return "Giữ sau thở - $remaining s";
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    _scrollController.dispose();
    _sw.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final contentWidth = math.max(
      screenSize.width,
      (_points.isNotEmpty ? _points.last.dx + 100 : screenSize.width),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Breathing Run")),
      body: Stack(
        children: [
          if(!_isCountingDown)...[
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: contentWidth,
                  height: screenSize.height,
                  child: CustomPaint(
                    painter: BreathingPathPainter(points: _points),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54, // nền mờ
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _currentPhaseText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ]
          else
            Center(
              child: Text(
                '$_countdown',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

          if(_controller != null && !_controller!.isAnimating)...[
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton(
                  onPressed: (){
                    _points.clear();
                    infinite = true;
                    _controller!.repeat();
                  },
                  child: Text('Vô hạn')
              ),
            ),

            Positioned(
              bottom: 20,
              right: 20,
              child: ElevatedButton(
                  onPressed: (){
                    _points.clear();
                    _controller!.repeat();
                  },
                  child: Text('Lặp lại')
              ),
            ),
          ]
        ],
      )
    );
  }
}

class BreathingPathPainter extends CustomPainter {
  final List<Offset> points;
  BreathingPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintDot = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Vẽ path
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paintLine);

    // Dot cuối
    final last = points.last;
    canvas.drawCircle(last, 8, paintDot);
  }

  @override
  bool shouldRepaint(covariant BreathingPathPainter oldDelegate) => true;
}
