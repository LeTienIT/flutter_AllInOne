import 'package:flutter/foundation.dart';

enum TimerMode { stopwatch, countdown }

enum TimerStatus { idle, running, paused, finished }

class PauseRecord {
  final Duration time;
  PauseRecord(this.time);
}

@immutable
class TimerState {
  final TimerMode mode;
  final TimerStatus status;
  final Duration elapsed;
  final Duration countdown;
  final List<PauseRecord> pauses;

  const TimerState({
    required this.mode,
    required this.status,
    required this.elapsed,
    required this.countdown,
    required this.pauses,
  });

  TimerState copyWith({
    TimerMode? mode,
    TimerStatus? status,
    Duration? elapsed,
    Duration? countdown,
    List<PauseRecord>? pauses,
  }) {
    return TimerState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      elapsed: elapsed ?? this.elapsed,
      countdown: countdown ?? this.countdown,
      pauses: pauses ?? this.pauses,
    );
  }

  static TimerState initial() => const TimerState(
    mode: TimerMode.stopwatch,
    status: TimerStatus.idle,
    elapsed: Duration.zero,
    countdown: Duration(seconds: 60),
    pauses: [],
  );
}
