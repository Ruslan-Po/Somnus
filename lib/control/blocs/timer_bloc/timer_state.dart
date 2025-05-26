abstract class TimerState {
  final int duration;

  TimerState(this.duration);
}

class InitialTimerState extends TimerState {
  InitialTimerState(super.duration);
}

class RunningTimerState extends TimerState {
  RunningTimerState(super.duration);
}

class PausedTimerState extends TimerState {
  PausedTimerState(super.duration);
}

class TimerCompleted extends TimerState {
  TimerCompleted() : super(0);
}
