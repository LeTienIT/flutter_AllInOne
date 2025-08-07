import 'package:flutter/material.dart';
import '../model/function_config.dart';

class FunctionParameterInput extends StatelessWidget {
  final FunctionType type;
  final TextEditingController controllerA;
  final TextEditingController controllerB;
  final TextEditingController controllerC;

  const FunctionParameterInput({
    super.key,
    required this.type,
    required this.controllerA,
    required this.controllerB,
    required this.controllerC,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case FunctionType.linear:
        return Row(
          children: [
            _buildField('A', controllerA),
            _buildField('B', controllerB),
          ],
        );
      case FunctionType.quadratic:
        return Row(
          children: [
            _buildField('A', controllerA),
            _buildField('B', controllerB),
            _buildField('C', controllerC),
          ],
        );
      default:
        return const Text('Không cần nhập tham số cho hàm này.');
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
