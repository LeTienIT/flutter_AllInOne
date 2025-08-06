import 'package:all_in_one_tool/app/tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:full_calender/enums/language_name.dart';
import 'package:full_calender/full_calender.dart';
import 'package:full_calender/full_calender_extension.dart';
import 'package:full_calender/models/lunar_date_time.dart';
import 'package:full_calender/models/stem_branch.dart';
import 'package:lunar_calendar_plus/lunar_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget{
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() {
    return _CalenderScreen();
  }

}
class _CalenderScreen extends ConsumerState<CalendarScreen>{
  DateTime now = DateTime.now();
  late DateTime? lunarDatetime;
  late bool luckyDay;
  List<bool> luckyHours = [];

  double _fabOpacity = 0.6;

  bool _initialized = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      _initialized = true;
      final lunar = FullCalender(date: now, timeZone: 7).lunarDate;
      setState(() {
        now = now;
        lunarDatetime = DateTime(lunar.year, lunar.month, lunar.day);
        luckyDay = lunar.isLuckyDay;
        luckyHours = lunar.listLuckyHours;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Lịch'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.blueAccent.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatVietnameseDate(now),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tức ngày ${lunarDatetime?.day} tháng ${lunarDatetime?.month} năm ${StemBranch.year(lunarDatetime!.year).name(LanguageName.vietNam)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            gioDepContainer(convertLuckyHours(luckyHours)),
            Padding(
              padding: EdgeInsets.all(16),
              child: LunarCalendar(
                onDateSelected: (solar, lunar) {
                  setState(() {
                    now = DateTime(solar.year, solar.month, solar.day);
                    lunarDatetime = DateTime(lunar.year, lunar.month, lunar.day);
                    luckyDay = FullCalender(date:now, timeZone: 7,).lunarDate.isLuckyDay;
                    luckyHours = FullCalender(date: now, timeZone: 7).lunarDate.listLuckyHours;
                  });
                },
                showTodayButton: true,
                enableDrag: true,
                showOutsideDays: true,
                theme: LunarCalendarTheme(
                  primaryColor: Colors.blue,
                  sundayColor: Colors.red,
                  saturdayColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Listener(
        onPointerDown: (_) => setState(() => _fabOpacity = 1.0),
        onPointerUp: (_) => setState(() => _fabOpacity = 0.6),
        child: AnimatedOpacity(
          opacity: _fabOpacity,
          duration: Duration(milliseconds: 200),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/calendar-more');
            },
          ),
        ),
      ),
    );
  }

  Widget gioDepContainer(List<GioDep> gioDepList) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.greenAccent.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '🕐 Các giờ hoàng đạo:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: gioDepList.map((gio) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.green.shade300,
                  child: Text(
                    gio.chi,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                label: Text(gio.timeRange),
                backgroundColor: Colors.green.shade100,
                labelStyle: const TextStyle(color: Colors.black),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              );
            }).toList(),
          ),
          const Text('Dữ liệu chỉ mang tính chất tham khảo',style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),textAlign: TextAlign.center,)
        ],
      ),
    );
  }


}