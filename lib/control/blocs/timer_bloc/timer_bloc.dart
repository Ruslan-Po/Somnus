import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somnus/control/blocs/timer_bloc/timer_event.dart';
import 'package:somnus/control/blocs/timer_bloc/timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int initialDuration = 0;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc() : super(InitialTimerState(initialDuration)) {
    on<StartTimerEvent>(_onStart);
    on<PauseTimerEvent>(_onPause);
    on<ResumeTimerEvent>(_onResume);
    on<ResetTimerEvent>(_onReset);
    on<TickEvent>(_onTick);
  }

  Stream<int> _tickerStream(int duration) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => duration - x - 1,
    ).take(duration);
  }

  void _onStart(StartTimerEvent event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();

    emit(RunningTimerState(event.duration));

    _tickerSubscription = _tickerStream(event.duration).listen((remaining) {
      add(TickEvent(remaining));
    });
  }

  void _onPause(PauseTimerEvent event, Emitter<TimerState> emit) {
    if (state is RunningTimerState) {
      _tickerSubscription?.pause();
      emit(PausedTimerState(state.duration));
    }
  }

  void _onResume(ResumeTimerEvent event, Emitter<TimerState> emit) {
    if (state is PausedTimerState) {
      _tickerSubscription?.resume();
      emit(RunningTimerState(state.duration));
    }
  }

  void _onReset(ResetTimerEvent event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(InitialTimerState(initialDuration));
  }

  void _onTick(TickEvent event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(RunningTimerState(event.duration));
    } else {
      emit(TimerCompleted());
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
