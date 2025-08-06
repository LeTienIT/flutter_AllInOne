import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/calendar_more_model.dart';

final dateRangeProvider = StateNotifierProvider<DateRangeNotifier, DateRangeState>(
      (ref) => DateRangeNotifier(),
);

class DateRangeNotifier extends StateNotifier<DateRangeState> {
  DateRangeNotifier() : super(DateRangeInitial());

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setStartDate(DateTime date) {
    _startDate = date;
  }

  void setEndDate(DateTime date) {
    _endDate = date;
  }

  Future<void> calculate() async {
    if (_startDate == null || _endDate == null) {
      state = DateRangeError(message: 'Không có dữ liệu để thực hiện');
      return;
    }

    state = DateRangeLoading();

    try {
      final daysBetween = _endDate!.difference(_startDate!).inDays;
      final startDay = int.parse(DateFormat("D").format(_startDate!));
      final endDay = int.parse(DateFormat("D").format(_endDate!));
      final startWeek = (_startDate!.difference(DateTime(_startDate!.year, 1, 1)).inDays ~/ 7) + 1;
      final endWeek = (_endDate!.difference(DateTime(_endDate!.year, 1, 1)).inDays ~/ 7) + 1;

      final holidays = await fetchHolidays(_startDate!.year);
      final filtered = holidays.where((h) => !h.date.isBefore(_startDate!) && !h.date.isAfter(_endDate!)).toList();

      state = DateRangeData(
        startDate: _startDate!,
        endDate: _endDate!,
        daysBetween: daysBetween,
        startDayOfYear: startDay,
        endDayOfYear: endDay,
        startWeekOfYear: startWeek,
        endWeekOfYear: endWeek,
        holidays: filtered,
      );
    } catch (e) {
      state = DateRangeError(message: e.toString());
    }
  }

  Future<List<Holiday>> fetchHolidays(int year) async {
    final url = Uri.parse('https://date.nager.at/api/v3/PublicHolidays/$year/VN');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Holiday.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi tải ngày lễ');
    }
  }
}
