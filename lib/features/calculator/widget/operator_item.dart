import 'package:flutter/material.dart';

class OperatorItem extends StatefulWidget{
  final String label;
  final VoidCallback onTap;
  
  const OperatorItem({super.key, required this.label, required this.onTap});
  
  @override
  State<OperatorItem> createState() {
    return _OperatorItem();
  }
  
}
class _OperatorItem extends State<OperatorItem> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _colorAnimation = ColorTween(
      begin: Colors.grey[200],
      end: Colors.orangeAccent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child){
            return Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(widget.label, style: const TextStyle(fontSize: 14)),
            );
          }
      ),
    );
  }

}