import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart' as uc;
import 'controller/converter.dart';
import 'controller/unit_list.dart';
import 'model/unit_model.dart';

class UnitScreen extends ConsumerStatefulWidget{
  const UnitScreen({super.key});

  @override
  ConsumerState<UnitScreen> createState() => _UnitScreen();

}

class _UnitScreen extends ConsumerState<UnitScreen>{
  UnitGroup selectedGroup = UnitGroup.length;
  dynamic fromUnit;
  dynamic toUnit;
  final input = TextEditingController(text: "1");
  final output = TextEditingController(text: "Kết quả");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    input.dispose();
    output.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitsMap = ref.watch(supportedUnitsProvider);
    final unitList = unitsMap[selectedGroup] ?? [];

    fromUnit ??= unitList.first;
    toUnit ??= unitList.length > 1 ? unitList[1] : unitList.first;

    ref.listen<AsyncValue<double>>(
      unitConvertProvider,
          (previous, next) {
        next.when(
          data: (val) => output.text = val.toStringAsFixed(4),
          loading: () => output.text = 'Đang chuyển đổi...',
          error: (e, _) => output.text = 'Lỗi: $e',
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Chuyển đổi đơn vị')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<UnitGroup>(
              value: selectedGroup,
              isExpanded: true,
              items: UnitGroup.values
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(unitGroupNames[e]!),
              ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedGroup = val;
                    final list = unitsMap[val]!;
                    fromUnit = list.first;
                    toUnit = list.length > 1 ? list[1] : list.first;
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            // Từ và đến
            Row(
              children: [
                Expanded(
                  child: DropdownButton<dynamic>(
                    value: fromUnit,
                    isExpanded: true,
                    items: unitList
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(formatUnitName(e)),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => fromUnit = val),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<dynamic>(
                    value: toUnit,
                    isExpanded: true,
                    items: unitList
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(formatUnitName(e)),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => toUnit = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Nhập giá trị
            TextField(
              controller: input,
              decoration: const InputDecoration(labelText: 'Giá trị cần chuyển'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // Kết quả
            TextField(
              controller: output,
              decoration: const InputDecoration(labelText: 'Kết quả'),
              readOnly: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final double? value = double.tryParse(input.text);
                if (value == null) {
                  output.text = 'Không hợp lệ';
                  return;
                }
                await ref.read(unitConvertProvider.notifier).convert(
                  group: selectedGroup,
                  fromUnit: fromUnit,
                  toUnit: toUnit,
                  value: value,
                );
              },
              child: const Text('Chuyển đổi'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Đơn vị hỗ trợ:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: unitList.map((e) => Chip(
                label: Text(formatUnitName(e)),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
  String formatUnitName(dynamic unit) {
    final raw = unit.toString().split('.').last;
    return raw[0].toUpperCase() + raw.substring(1).replaceAll('_', ' ');
  }
}