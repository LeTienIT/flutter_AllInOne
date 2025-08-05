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

String _formatHour(int h) => h.toString().padLeft(2, '0') + ':00';