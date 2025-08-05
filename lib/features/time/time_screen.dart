import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/timer_controller.dart';
import 'model/timer_model.dart';

class TimeScreen extends ConsumerStatefulWidget{
  const TimeScreen({super.key});

  @override
  ConsumerState<TimeScreen> createState() {
    return _TimeScreen();
  }

}

class _TimeScreen extends ConsumerState<TimeScreen>{
  late var input = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = ref.read(timerControllerProvider).countdown;
    input = TextEditingController(text: '${initial.inSeconds}');
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timerControllerProvider);
    final controller = ref.read(timerControllerProvider.notifier);

    final currentInput = int.tryParse(input.text);

    if (state.mode == TimerMode.countdown && currentInput != state.countdown.inSeconds) {
      input.text = '${state.countdown.inSeconds}';
      input.selection = TextSelection.fromPosition(
        TextPosition(offset: input.text.length),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Đếm thời gian'),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              controller.displayTime,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ToggleButtons(
              isSelected: [
                state.mode == TimerMode.stopwatch,
                state.mode == TimerMode.countdown,
              ],
              onPressed: (index) {
                final selected = TimerMode.values[index];
                controller.setMode(selected);
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Bộ đếm'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Đếm ngược'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if(state.mode == TimerMode.countdown)...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: input,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Nhập số giây'),
                    ),
                  ),
                  SizedBox(width: 10,),

                  ElevatedButton(
                      onPressed: (){
                        final int? value = int.tryParse(input.text);
                        if (value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dữ liệu không hợp lệ'), backgroundColor: Colors.redAccent,));
                          return;
                        }
                        input.text = '$value}';
                        controller.setTimeCountdown(Duration(seconds: value));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thiết lập thành công'), backgroundColor: Colors.green,));
                      },
                      child: Padding(padding: EdgeInsets.all(16),child: Icon(Icons.check),)
                  )
                ],
              ),
              SizedBox(height: 10,),
              Divider(height: 1,),
              SizedBox(height: 10,),
            ],

            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: controller.start,
                  child: const Text('Bắt đầu'),
                ),
                const SizedBox(width: 11),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: controller.pause,
                  child: const Text('Tạm dừng'),
                ),
                const SizedBox(width: 11),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: controller.stop,
                  child: const Text('Dừng'),
                ),
                const SizedBox(width: 11),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: controller.resetAll,
                  child: const Text('Đặt lại'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Divider(height: 1,),

            Expanded(
              child: ListView.builder(
                itemCount: state.pauses.length,
                itemBuilder: (_, index) {
                  final pause = state.pauses[index];
                  final time = pause.time;
                  String two(int n) => n.toString().padLeft(2, '0');
                  final text =
                      '${two(time.inMinutes)}:${two(time.inSeconds % 60)}.${(time.inMilliseconds % 1000).toString().padLeft(3, '0')}';

                  return ListTile(
                    leading: Text('#${index + 1}'),
                    title: Text('Paused at $text'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}