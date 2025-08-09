import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

String formatVietnameseDate(DateTime date) {
  const weekdays = {
    1: 'Thứ Hai',
    2: 'Thứ Ba',
    3: 'Thứ Tư',
    4: 'Thứ Năm',
    5: 'Thứ Sáu',
    6: 'Thứ Bảy',
    7: 'Chủ Nhật',
  };

  final weekdayName = weekdays[date.weekday] ?? '';
  final day = date.day;
  final month = date.month;
  final year = date.year;

  return '$weekdayName, ngày $day tháng $month NĂM $year';
}

class GioDep {
  final String chi;      // ví dụ: "Tý"
  final String timeRange; // ví dụ: "23:00 - 01:00"

  GioDep(this.chi, this.timeRange);
}

List<GioDep> convertLuckyHours(List<bool> hours) {
  const gioChi = [
    'Tý', 'Sửu', 'Dần', 'Mão', 'Thìn', 'Tỵ',
    'Ngọ', 'Mùi', 'Thân', 'Dậu', 'Tuất', 'Hợi'
  ];

  final result = <GioDep>[];

  for (int i = 0; i < 12; i++) {
    if (hours[i]) {
      final start = (23 + i * 2) % 24;
      final end = (start + 2) % 24;

      final timeRange = '${_formatHour(start)} - ${_formatHour(end)}';
      result.add(GioDep(gioChi[i], timeRange));
    }
  }

  return result;
}

String _formatHour(int h) => '${h.toString().padLeft(2, '0')}:00';

double? parseInput(String input) {
  final value = double.tryParse(input.trim());
  return value;
}

void showError(BuildContext context, String errTitle, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(errTitle),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    ),
  );
}

Future<void> cleanOnlyCache() async {
  try {
    // 1. Xóa thư mục cache tạm thời (temporary directory)
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
      await tempDir.create(); // Tạo lại thư mục rỗng
    }

    // 2. Xóa cache của các package (image, network...)
    await DefaultCacheManager().emptyCache(); // cached_network_image
    // Xóa cache của Dio (nếu dùng)
    final dioCacheDir = Directory('${tempDir.path}/dio');
    if (await dioCacheDir.exists()) await dioCacheDir.delete(recursive: true);

    // 3. Xóa cache WebView (nếu app dùng WebView)
    final appDir = await getApplicationSupportDirectory();
    final webViewCacheDir = Directory('${appDir.path}/WebKit');
    if (await webViewCacheDir.exists()) {
      await webViewCacheDir.delete(recursive: true);
    }
  } catch (e) {
    throw Exception(e);
  }
}