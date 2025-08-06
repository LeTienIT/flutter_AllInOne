import 'package:all_in_one_tool/features/calendar/model/calendar_more_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'controller/calendar_more.dart';

class CalendarMoreScreen extends ConsumerStatefulWidget{
  const CalendarMoreScreen({super.key});

  @override
  ConsumerState<CalendarMoreScreen> createState() {
    return _CalendarMoreScreen();
  }
}
class _CalendarMoreScreen extends ConsumerState<CalendarMoreScreen>{
  DateTime? select_1, select_2;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dateRangeProvider);
    final notifier = ref.read(dateRangeProvider.notifier);
    select_1 = notifier.startDate;
    select_2 = notifier.endDate;

    return Scaffold(
      appBar: AppBar(title: Text('Thời gian'),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5), // Màu bóng
                    spreadRadius: 2, // Độ lan rộng của bóng
                    blurRadius: 5,   // Độ mờ của bóng
                    offset: Offset(2, 3),
                  )
                ]
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(child: Column(
                          children: [
                            Text(select_1 == null ? 'Chọn ngày' : DateFormat('dd-MM-yyyy').format(select_1!)),
                            ElevatedButton.icon(
                              onPressed: () async {
                                var day = await showDatePicker(
                                    context: context,
                                    initialDate: select_1,
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime(DateTime.now().year + 5)
                                );
                                if(day != null){
                                  notifier.setStartDate(day);
                                  setState(() {
                                    select_1 = day;
                                  });
                                }
                              },
                              label: Icon(Icons.calendar_month),
                            ),
                          ],
                        )),
                        Expanded(child: Column(
                          children: [
                            Text(select_2 == null ? 'Chọn ngày' : DateFormat('dd-MM-yyyy').format(select_2!)),
                            ElevatedButton.icon(
                              onPressed: () async {
                                var day = await showDatePicker(
                                    context: context,
                                    initialDate: select_2,
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime(DateTime.now().year + 5)
                                );
                                if(day != null){
                                  notifier.setEndDate(day);
                                  setState(() {
                                    select_2 = day;
                                  });
                                }
                              },
                              label: Icon(Icons.calendar_month),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                          notifier.calculate();
                       },
                      child: Text('Tính toán')
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5), // Màu bóng
                      spreadRadius: 2, // Độ lan rộng của bóng
                      blurRadius: 5,   // Độ mờ của bóng
                      offset: Offset(2, 3),
                    )
                  ]
              ),
              child: switch(state){
                DateRangeLoading() => CircularProgressIndicator(),
                DateRangeError(:final message) => Center(child: Text("Lỗi: $message", style: TextStyle(color: Colors.red)),),
                DateRangeInitial() => const Center(child: Text("Chưa có dữ liệu"),),
                DateRangeData(:final startDate, :final endDate, :final daysBetween,
                    :final startDayOfYear, :final endDayOfYear, :final startWeekOfYear,
                    :final endWeekOfYear, :final holidays) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Text('Dữ liệu tính toán',style: Theme.of(context).textTheme.titleSmall,),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "• "),
                          TextSpan(text: "Khoảng cách giữa 2 ngày:  ", style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "$daysBetween ngày"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "• "),
                          TextSpan(text: "Ngày: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "${DateFormat('dd-MM-yyyy').format(startDate)} "),
                          TextSpan(text: "(Ngày thứ $startDayOfYear, Tuần $startWeekOfYear)"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "• "),
                          TextSpan(text: "Ngày kết thúc: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "${DateFormat('dd-MM-yyyy').format(endDate)} "),
                          TextSpan(text: "(Ngày thứ $endDayOfYear, Tuần $endWeekOfYear)"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      "🎉 Ngày lễ công khai trong khoảng thời gian:",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),

                    if (holidays.isEmpty)
                      const Text("- Không có ngày lễ nào trong khoảng này."),
                    if (holidays.isNotEmpty)
                      ...holidays.map((h) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.event, size: 20),
                        title: Text(
                          DateFormat('dd/MM/yyyy').format(h.date),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(h.name),
                      )),
                  ],
                )
              },
            ),
          ],
        ),
      ),
    );
  }

}