import 'package:flutter/material.dart';

class HistoryItem extends StatefulWidget {
  final String expression;
  final String result;
  final VoidCallback onTap;

  const HistoryItem({
    super.key,
    required this.expression,
    required this.result,
    required this.onTap,
  });

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  bool _tapped = false;

  void _handleTap() {
    setState(() {
      _tapped = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _tapped = false;
        });
      }
    });

    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: _tapped
              ? LinearGradient(
            colors: [Colors.orange, Colors.yellow],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : null,
          color: _tapped ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${widget.expression} = ${widget.result}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
