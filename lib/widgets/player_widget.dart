// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:somnus/control/audio_handler.dart';
import 'package:somnus/models/sound_model.dart';
import 'package:somnus/style/styles.dart';

class PlayerWidget extends StatefulWidget {
  final SoundModel sound;
  final bool stopSignal;
  final LocalAudioHandler audioHandler;

  const PlayerWidget({
    super.key,
    required this.sound,
    required this.stopSignal,
    required this.audioHandler,
  });

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  bool? _isPlaying;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();

    widget.audioHandler.isPlaying(widget.sound.filePath).then((playing) {
      if (!playing) {
        widget.audioHandler.playSound(widget.sound.filePath, volume: _volume);
      }
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant PlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stopSignal) {
      widget.audioHandler.pauseSound(widget.sound.filePath);
    }
  }

  void _togglePlayPause() {
    widget.audioHandler.togglePlayPause(widget.sound.filePath);
  }

  void _changeVolume(double value) async {
    await widget.audioHandler.setVolume(widget.sound.filePath, value);
    setState(() {
      _volume = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPlaying == null) {
      return const SizedBox(height: 80);
    }

    return Row(
      children: [
        const SizedBox(width: 10),
        Container(
          width: 90,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.sound.iconPath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.sound.iconPath!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint(
                          'Ошибка загрузки изображения: ${widget.sound.iconPath}');
                      return const Icon(Icons.error, color: Colors.red);
                    },
                  ),
                )
              : const Icon(Icons.music_note, color: Colors.white),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: Slider(
            activeColor: AppStyles.secondaryAccent,
            inactiveColor: Colors.black12,
            min: 0.0,
            max: 1.0,
            value: _volume,
            onChanged: _changeVolume,
          ),
        ),
        SizedBox(
          width: 30,
          child: StreamBuilder<bool>(
            stream: widget.audioHandler.playingStream(widget.sound.filePath),
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: IconButton(
                  key: ValueKey(isPlaying),
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
