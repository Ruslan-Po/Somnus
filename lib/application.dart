import 'package:flutter/material.dart';
import 'package:somnus/control/audio_handler.dart';
import 'package:somnus/screens/home_screen.dart';

class App extends StatelessWidget {
  final LocalAudioHandler audioHandler;

  const App({
    super.key,
    required this.audioHandler,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(audioHandler: audioHandler),
    );
  }
}
