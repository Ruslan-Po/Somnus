abstract class TimerEvent {}

class StartTimerEvent extends TimerEvent {
  final int duration;

  StartTimerEvent(this.duration);
}

class PauseTimerEvent extends TimerEvent {}

class ResumeTimerEvent extends TimerEvent {}

class ResetTimerEvent extends TimerEvent {}

class TickEvent extends TimerEvent {
  final int duration;

  TickEvent(this.duration);
}
