import 'dart:math';
import 'package:flutter/material.dart';

class DangerousCoinFlip extends StatefulWidget {
  const DangerousCoinFlip({super.key});

  @override
  State<DangerousCoinFlip> createState() => _DangerousCoinFlipState();
}

class _DangerousCoinFlipState extends State<DangerousCoinFlip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHead = true;
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isFlipping = false);
      }
    });
  }

  void _flipCoin() {
    if (_isFlipping) return;
    setState(() {
      _isHead = Random().nextBool();
      _isFlipping = true;
    });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // nền tối
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.redAccent,
                  Colors.black,
                  Colors.black,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Coin
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = Curves.easeInOut.transform(_controller.value);

                // --- Coin bay lên & rơi xuống ---
                final offsetY = -250 * sin(pi * t);

                const mid = 0.6;
                double angleX, angleY, angleZ;

                if (t < mid) {
                  angleX = pi * 8 * t + sin(t * 25) * 0.7;
                  angleY = pi * 12 * t + cos(t * 18) * 0.6;
                  angleZ = sin(t * 10) * 0.4;
                } else {
                  final settleT =
                  Curves.easeOutCubic.transform((t - mid) / (1 - mid));
                  const extraRounds = 10;

                  angleX = sin(settleT * pi * 4) * 0.2;
                  angleZ = cos(settleT * pi * 3) * 0.2;

                  angleY = (_isHead ? 0.0 : pi) +
                      pi * 2 * extraRounds * settleT;
                }

                double normalized = (angleY % (2 * pi)) / pi;
                final frontOpacity = (1 - normalized).clamp(0.0, 1.0);
                final backOpacity = normalized.clamp(0.0, 1.0);

                // Nhấp nháy ánh sáng khi flipping
                final flashOpacity = _isFlipping ? (sin(t * 20 * pi) * 0.5 + 0.5) : 0.0;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..translate(0.0, offsetY, 0.0)
                        ..rotateX(angleX)
                        ..rotateY(angleY)
                        ..rotateZ(angleZ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: frontOpacity,
                            child: Image.asset(
                              "assets/coin_front.png",
                              width: 200,
                            ),
                          ),
                          Opacity(
                            opacity: backOpacity,
                            child: Image.asset(
                              "assets/coin_back.png",
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_isFlipping)
                      Opacity(
                        opacity: flashOpacity,
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Button Tung!
          if (!_isFlipping)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _flipCoin,
                  child: const Text("TUNG!"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
