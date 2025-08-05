import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/timer_model.dart';

final timerControllerProvider = NotifierProvider<TimerController, TimerState>(() => TimerController());

class TimerController extends Notifier<TimerState> {
  Timer? _ticker;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  TimerState build() => TimerState.initial();

  void setMode(TimerMode mode) {
    stop();
    state = state.copyWith(mode: mode, status: TimerStatus.idle);
  }

  void setTimeCountdown(Duration s){
    stop();
    state = state.copyWith(countdown: s);
  }
  void start() {
    if (state.status == TimerStatus.running) return;

    if (state.mode == TimerMode.stopwatch) {
      _stopwatch.start();
    }

    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (state.mode == TimerMode.stopwatch) {
        state = state.copyWith(
          status: TimerStatus.running,
          elapsed: _stopwatch.elapsed,
        );
      }
      else {
        if (state.countdown.inMilliseconds <= 0) {
          stop();
          state = state.copyWith(status: TimerStatus.finished);
          return;
        }

        state = state.copyWith(
          status: TimerStatus.running,
          countdown: state.countdown - const Duration(milliseconds: 100),
        );
      }
    });
  }

  void pause() {
    if (state.status != TimerStatus.running) return;

    List<PauseRecord> updated = [...state.pauses];

    if (state.mode == TimerMode.stopwatch) {
      updated.add(PauseRecord(_stopwatch.elapsed));
    } else {
      updated.add(PauseRecord(state.countdown));
    }

    state = state.copyWith(status: TimerStatus.paused, pauses: updated);
  }

  void stop() {
    _ticker?.cancel();
    _ticker = null;
    _stopwatch.stop();
    _stopwatch.reset();

    state = state.copyWith(
      status: TimerStatus.idle,
      elapsed: Duration.zero,
      countdown: Duration(seconds: 60),
    );
  }

  void resetAll() {
    _ticker?.cancel();
    _ticker = null;
    _stopwatch.stop();
    _stopwatch.reset();

    state = state.copyWith(
      status: TimerStatus.idle,
      elapsed: Duration.zero,
      countdown: Duration(seconds: 60),
      pauses: [],
    );
  }

  String get displayTime {
    final Duration d = state.mode == TimerMode.stopwatch
        ? state.elapsed
        : state.countdown;

    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes)}:${two(d.inSeconds % 60)}.${(d.inMilliseconds % 1000).toString().padLeft(3, '0')}';
  }
}
