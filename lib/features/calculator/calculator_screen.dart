import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  double _value = 0.0;
  final List<String> _history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Máy tính'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: SimpleCalculator(
              value: _value,
              hideExpression: false,
              hideSurroundingBorder: false,
              onChanged: (key, value, expression) {
                setState(() {
                  _value = value ?? 0;
                  if ((expression?.isNotEmpty == true) && key == '=') {
                    _history.add('$expression = ${_value.toStringAsFixed(1)}');
                  }
                  if(key == 'AC'){
                    _history.clear();
                  }
                });
              },
              theme: const CalculatorThemeData(
                borderColor: Colors.transparent,
                displayColor: Colors.black,
                displayStyle: TextStyle(fontSize: 24, color: Colors.white),
                expressionColor: Colors.grey,
                expressionStyle: TextStyle(fontSize: 18, color: Colors.white70),
                operatorColor: Colors.orange,
                commandColor: Colors.grey,
                numColor: Colors.black54,
                numStyle: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ),
          const Divider(color: Colors.white54),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Lịch sử',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            flex: 1,
            child: _history.isEmpty ? Center(child: Text('Chưa có phép tính nào', style: Theme.of(context).textTheme.bodySmall)) : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[_history.length - 1 - index];
                return ListTile(
                  title: Text(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
