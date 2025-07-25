import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class LocalAudioHandler extends BaseAudioHandler {
  final Map<String, AudioPlayer> _players = {};
  final Map<String, BehaviorSubject<bool>> _playingControllers = {};
  Timer? _sleepTimer;

  LocalAudioHandler() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  Future<void> _fadeVolume(
    AudioPlayer player, {
    required double from,
    required double to,
    Duration duration = const Duration(seconds: 1),
    int steps = 20,
  }) async {
    final stepDur = duration ~/ steps;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      await player.setVolume(from + (to - from) * t);
      await Future.delayed(stepDur);
    }
  }

  Future<void> playSound(String path, {double volume = 0.5}) async {
    final fullAssetPath = 'assets/$path';
    final player = AudioPlayer();

    try {
      await player.setAsset(fullAssetPath);
      await player.setLoopMode(LoopMode.one);
      await player.setVolume(volume);

      _players[path] = player;

      final controller =
          _playingControllers[path] ?? BehaviorSubject<bool>.seeded(false);
      _playingControllers[path] = controller;

      player.playingStream.listen(controller.add);

      await player.play();
      debugPrint('Playing: $fullAssetPath');
    } catch (e) {
      debugPrint('Ошибка при воспроизведении $fullAssetPath: $e');
    }
  }

  /// Stop a single sound by [path]
  Future<void> stopSound(String path) async {
    final player = _players[path];
    if (player != null) {
      final currentVol = player.volume;
      await _fadeVolume(player, from: currentVol, to: 0);
      await player.stop();
      await player.dispose();
      _players.remove(path);
      _playingControllers[path]?.add(false);
    }
  }

  Future<void> pauseSound(String path) async {
    final player = _players[path];
    if (player != null && player.playing) {
      await player.pause();
      _playingControllers[path]?.add(false);
    }
  }

  Future<void> stopAll() async {
    final players = List<AudioPlayer>.from(_players.values);
    for (final player in players) {
      final currentVol = player.volume;
      await _fadeVolume(player, from: currentVol, to: 0);
      await player.stop();
      await player.dispose();
    }
    _players.clear();
    for (final controller in _playingControllers.values) {
      controller.add(false);
    }
    cancelSleepTimer();
  }

  Future<void> togglePlayPause(String path) async {
    final player = _players[path];
    if (player == null) return;
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> setVolume(String path, double vol) async {
    final player = _players[path];
    if (player != null) {
      await player.setVolume(vol);
    }
  }

  Stream<bool> playingStream(String path) {
    return _playingControllers
        .putIfAbsent(
          path,
          () => BehaviorSubject<bool>.seeded(false),
        )
        .stream
        .distinct();
  }

  Future<bool> isPlaying(String path) async {
    final player = _players[path];
    return player?.playing ?? false;
  }

  void startSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    _sleepTimer = Timer(duration, () async {
      await stopAll();
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
  }

  @override
  Future<void> play() async {
    for (final player in _players.values) {
      if (!player.playing) {
        await player.play();
      }
    }
  }

  @override
  Future<void> pause() async {
    for (final player in _players.values) {
      if (player.playing) {
        await player.pause();
      }
    }
  }

  @override
  Future<void> stop() async {
    await stopAll();
  }
}
