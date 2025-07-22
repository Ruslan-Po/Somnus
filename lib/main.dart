import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somnus/application.dart';
import 'package:somnus/control/audio_handler.dart';
import 'package:somnus/control/blocs/player_bloc/playlist_bloc.dart';

late final LocalAudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Future.delayed(Duration.zero);

  audioHandler = await AudioService.init(
    builder: () => LocalAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ruslee.somnus.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    ),
  );

  runApp(
    BlocProvider(
      create: (_) => PlaylistBloc(audioHandler),
      child: App(audioHandler: audioHandler),
    ),
  );
}
