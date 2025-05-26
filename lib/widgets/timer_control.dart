import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somnus/control/blocs/timer_bloc/timer_bloc.dart';
import 'package:somnus/control/blocs/timer_bloc/timer_event.dart';
import 'package:somnus/control/blocs/timer_bloc/timer_state.dart';
import 'package:somnus/style/positional.dart';
import 'package:somnus/style/styles.dart';

class TimerControlWidget extends StatefulWidget {
  final void Function()? onTimerComplete;

  const TimerControlWidget({
    super.key,
    this.onTimerComplete,
  });

  @override
  State<TimerControlWidget> createState() => _TimerControlWidgetState();
}

class _TimerControlWidgetState extends State<TimerControlWidget> {
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _secondController;
  final FixedExtentScrollController _hourController =
      FixedExtentScrollController();
  int _selectedHours = 0;

  @override
  void initState() {
    super.initState();
    _minuteController = FixedExtentScrollController(initialItem: 6000);
    _secondController = FixedExtentScrollController(initialItem: 6000);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerCompleted && widget.onTimerComplete != null) {
          widget.onTimerComplete!();
        }
      },
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final totalSeconds = state.duration;
          final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
          final minutes =
              ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
          final seconds = (totalSeconds % 60).toString().padLeft(2, '0');

          final isRunning = state is RunningTimerState;
          final isPaused = state is PausedTimerState;

          return Column(
            children: [
              const Text(
                'Set Timer',
                style: TextStyle(color: Color(0xFF5b61b2)),
              ),
              const SizedBox(height: 15),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isRunning
                    ? const SizedBox.shrink()
                    : SizedBox(
                        key: const ValueKey('time-pickers'),
                        height: 100,
                        width: 200,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _hourController,
                                    itemExtent: 40,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _selectedHours = index % 24;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      childCount: null,
                                      builder: (context, index) {
                                        final value = index % 24;
                                        final formatted =
                                            value.toString().padLeft(2, '0');
                                        return Center(
                                            child: Text('$formatted h'));
                                      },
                                    ),
                                  ),
                                ),
                                const Text(':'),
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _minuteController,
                                    itemExtent: 40,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _selectedMinutes = index % 60;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      childCount: null,
                                      builder: (context, index) {
                                        final value = index % 60;
                                        final formatted =
                                            value.toString().padLeft(2, '0');
                                        return Center(
                                            child: Text('$formatted m'));
                                      },
                                    ),
                                  ),
                                ),
                                const Text(':'),
                                Expanded(
                                  child: ListWheelScrollView.useDelegate(
                                    controller: _secondController,
                                    itemExtent: 40,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        _selectedSeconds = index % 60;
                                      });
                                    },
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      childCount: null,
                                      builder: (context, index) {
                                        final value = index % 60;
                                        final formatted =
                                            value.toString().padLeft(2, '0');
                                        return Center(
                                            child: Text('$formatted s'));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const ListFadeOverlay(
                                fadeColor: Color(0xFF6DA0E1), height: 15),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 15),
              Text(
                _selectedHours > 0
                    ? '$hours:$minutes:$seconds'
                    : '$minutes:$seconds',
                style: AppStyles.timerText,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    text: 'Start',
                    onTap: () {
                      final selectedHours = _hourController.selectedItem % 24;
                      final selectedMinutes =
                          _minuteController.selectedItem % 60;
                      final selectedSeconds =
                          _secondController.selectedItem % 60;

                      final totalSeconds = selectedHours * 3600 +
                          selectedMinutes * 60 +
                          selectedSeconds;

                      context
                          .read<TimerBloc>()
                          .add(StartTimerEvent(totalSeconds));
                      setState(() {
                        _selectedHours = selectedHours;
                        _selectedMinutes = selectedMinutes;
                        _selectedSeconds = selectedSeconds;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildControlButton(
                    text: isPaused ? 'Go on' : 'Pause',
                    onTap: () {
                      if (isPaused) {
                        context.read<TimerBloc>().add(ResumeTimerEvent());
                      } else {
                        context.read<TimerBloc>().add(PauseTimerEvent());
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildControlButton(
                    text: 'Reset',
                    onTap: () =>
                        context.read<TimerBloc>().add(ResetTimerEvent()),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlButton(
      {required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppStyles.primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(100, 0, 0, 0),
              blurRadius: 7,
              offset: const Offset(2, 2),
            ),
            BoxShadow(
              color: const Color.fromARGB(100, 255, 255, 255),
              blurRadius: 7,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: SizedBox(
            width: 50,
            child: Center(child: Text(text, style: AppStyles.buttons))),
      ),
    );
  }
}
