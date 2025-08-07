import 'package:all_in_one_tool/features/calculator/widget/history_item.dart';
import 'package:all_in_one_tool/features/calculator/widget/operator_item.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class ExpressionCalculatorScreen extends StatefulWidget {
  const ExpressionCalculatorScreen({super.key});

  @override
  State<ExpressionCalculatorScreen> createState() => _ExpressionCalculatorScreenState();
}

class _ExpressionCalculatorScreenState extends State<ExpressionCalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _result = '';
  final Map<String, String> _history = {};

  void _evaluateExpression() {
    final input = _controller.text.trim();
    try {
      GrammarParser p = GrammarParser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = eval.toString();
        if (input.isNotEmpty) {
          _history[input] = _result;
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Lỗi: Biểu thức không hợp lệ';
      });
    }
  }

  void _loadFromHistory(String expression) {
    setState(() {
      _controller.text = expression;
    });
  }

  void _insertAtCursor(String text) {
    final currentText = _controller.text;
    final selection = _controller.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      text,
    );
    setState(() {
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(offset: selection.start + text.length);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final operators = [
      '+', '-', '*', '/', '%', '^',
      '(', ')', 'pi', 'e',
      'sqrt( X )', 'abs( X )', 'log( X )', 'ln( X )', 'exp( X )',
      'sin( X )', 'cos( X )', 'tan( X )', 'asin( X )', 'acos( X )', 'atan( X )',
      'floor( X )', 'ceil( X )', 'round( X )', 'sign( X )'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Nhập biểu thức')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: false,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nhập biểu thức (ví dụ: 2 * (3 + 4))',
                ),
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Kết quả: $_result',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _result = '0.0';
                        _controller.text = '';
                        _history.clear();
                      });
                    },
                    child: const Icon(Icons.delete),
                  ),
                  ElevatedButton(
                    onPressed: _evaluateExpression,
                    child: const Text('=', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
              const Divider(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: operators.map((op) {
                  return OperatorItem(
                    label: op,
                    onTap: () => _insertAtCursor(op),
                  );
                }).toList(),
              ),
              const Divider(height: 10),
              const SizedBox(height: 8),
              if (_history.isEmpty)
                const Text('Chưa có biểu thức nào')
              else
                Column(
                  children: _history.entries.toList().reversed.map((entry) {
                    return HistoryItem(
                      expression: entry.key,
                      result: entry.value,
                      onTap: () => _loadFromHistory(entry.key),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      )
    );
  }
}
