import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomMappingDialog extends StatefulWidget {
  const CustomMappingDialog({super.key});

  @override
  State<CustomMappingDialog> createState() => _CustomMappingDialogState();
}

class _CustomMappingDialogState extends State<CustomMappingDialog> {
  final TextEditingController _controller = TextEditingController();
  Map<String, String> _mapping = {};

  @override
  void initState() {
    super.initState();
    _loadMapping();
  }

  Future<void> _loadMapping() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("custom_mapping");
    if (saved != null) {
      setState(() {
        _mapping = Map<String, String>.from(jsonDecode(saved));
        // chuyển map thành text
        _controller.text = _mapping.entries.map((e) => "${e.key} - ${e.value}").join("\n");
      });
    } else {
      // mặc định: 15 dòng trống
      _controller.text = List.generate(15, (_) => "").join("\n");
    }
  }

  Future<void> _saveMapping() async {
    final prefs = await SharedPreferences.getInstance();

    // parse text → map
    final lines = _controller.text.split("\n");
    final map = <String, String>{};
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      final parts = line.split("-");
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join("-").trim(); // phòng trường hợp value có "-"
        map[key] = value;
      }
    }

    await prefs.setString("custom_mapping", jsonEncode(map));
    Navigator.pop(context, map);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Mảng mã hóa:\n A - @\n a - &"),
      content: TextField(
        controller: _controller,
        minLines: 15,
        maxLines: 16,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Ví dụ: A - !!!",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: _saveMapping,
          child: const Text("Lưu"),
        ),
      ],
    );
  }
}
