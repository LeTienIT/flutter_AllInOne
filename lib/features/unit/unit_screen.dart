import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/unit_library/unit_definition.dart';
import '../../core/unit_library/unit_library_main.dart';

class UnitScreen extends ConsumerStatefulWidget{
  const UnitScreen({super.key});

  @override
  ConsumerState<UnitScreen> createState() => _UnitScreen();

}

class _UnitScreen extends ConsumerState<UnitScreen>{
  final input = TextEditingController(text: "1");
  final output = TextEditingController(text: "Kết quả");

  UnitCategory? _loaiDangChon;
  List<UnitDefinition> _dsDonVi = [];

  UnitDefinition? _donViTu;
  UnitDefinition? _donViDen;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Chuyển đổi đơn vị')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<UnitCategory>(
              value: _loaiDangChon,
              decoration: InputDecoration(
                labelText: 'Chọn loại đơn vị',
                border: OutlineInputBorder(), // Viền đẹp
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: UnitCategory.values.map((loai) {
                return DropdownMenuItem(
                  value: loai,
                  child: Text(UnitLibrary.tenLoai(loai)), // Dùng tên tiếng Việt
                );
              }).toList(),
              onChanged: (loaiMoi) {
                setState(() {
                  _loaiDangChon = loaiMoi;
                  _dsDonVi = UnitLibrary.getUnitsByCategory(loaiMoi!);
                  _donViTu = null;
                  _donViDen = null;
                });
              },
            ),
            SizedBox(height: 12),

            DropdownButtonFormField<UnitDefinition>(
              value: _donViTu,
              decoration: InputDecoration(
                labelText: 'Từ đơn vị',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _dsDonVi.map((donvi) {
                return DropdownMenuItem(
                  value: donvi,
                  child: Text('${donvi.ten} (${donvi.kyHieu})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _donViTu = value);
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<UnitDefinition>(
              value: _donViDen,
              decoration: InputDecoration(
                labelText: 'Sang đơn vị',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _dsDonVi.map((donvi) {
                return DropdownMenuItem(
                  value: donvi,
                  child: Text('${donvi.ten} (${donvi.kyHieu})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _donViDen = value);
              },
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
                if (_donViTu == null || _donViDen == null) {
                  setState(() {
                    output.text = 'Chưa chọn đơn vị';
                  });
                  return;
                }

                try {
                  final result = UnitLibrary.convert(value, _donViTu!.unitId, _donViDen!.unitId);
                  setState(() {
                    final hienThi = '${UnitLibrary.formatSoDonVi(result)} ${_donViDen!.kyHieu}';
                    output.text = hienThi;
                  });
                } catch (e) {
                  setState(() {
                    output.text = 'Lỗi: ${e.toString()}';
                  });
                }
              },
              child: const Text('Chuyển đổi'),
            ),

            const SizedBox(height: 24),
            const Divider(),
            if (_donViTu?.moTa != null)...[
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  _donViTu!.moTa!,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
            ],
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
              children: _dsDonVi.map((e) => Chip(
                label: Text('${e.ten} (${e.kyHieu})'),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}