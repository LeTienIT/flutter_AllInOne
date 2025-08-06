class Holiday {
  final String name;
  final DateTime date;

  Holiday({required this.name, required this.date});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['localName'],
      date: DateTime.parse(json['date']),
    );
  }
}

sealed class DateRangeState {}

class DateRangeData extends DateRangeState {
  final DateTime startDate;
  final DateTime endDate;
  final int daysBetween;
  final int startDayOfYear;
  final int endDayOfYear;
  final int startWeekOfYear;
  final int endWeekOfYear;
  final List<Holiday> holidays;

  DateRangeData({
    required this.startDate,
    required this.endDate,
    required this.daysBetween,
    required this.startDayOfYear,
    required this.endDayOfYear,
    required this.startWeekOfYear,
    required this.endWeekOfYear,
    required this.holidays,
  });

  DateRangeData copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? daysBetween,
    int? startDayOfYear,
    int? endDayOfYear,
    int? startWeekOfYear,
    int? endWeekOfYear,
    List<Holiday>? holidays,
  }) {
    return DateRangeData(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysBetween: daysBetween ?? this.daysBetween,
      startDayOfYear: startDayOfYear ?? this.startDayOfYear,
      endDayOfYear: endDayOfYear ?? this.endDayOfYear,
      startWeekOfYear: startWeekOfYear ?? this.startWeekOfYear,
      endWeekOfYear: endWeekOfYear ?? this.endWeekOfYear,
      holidays: holidays ?? this.holidays,
    );
  }
}

class DateRangeLoading extends DateRangeState {}

class DateRangeError extends DateRangeState {
  final String message;
  DateRangeError({required this.message});
}

class DateRangeInitial extends DateRangeState {}

