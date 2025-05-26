// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:somnus/control/audio_handler.dart';
import 'package:somnus/control/blocs/player_bloc/playlist_bloc.dart';
import 'package:somnus/control/blocs/player_bloc/playlist_events.dart';
import 'package:somnus/control/blocs/player_bloc/playlist_state.dart';
import 'package:somnus/control/blocs/timer_bloc/timer_bloc.dart';
import 'package:somnus/models/playlist_model.dart';
import 'package:somnus/models/sound_model.dart';
import 'package:somnus/style/positional.dart';
import 'package:somnus/style/styles.dart';
import 'package:somnus/widgets/player_widget.dart';
import 'package:somnus/widgets/timer_control.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistId;
  final LocalAudioHandler audioHandler;

  const PlaylistScreen({
    super.key,
    required this.playlistId,
    required this.audioHandler,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool stopAll = false;

  List<SoundModel> getAvailableSounds() {
    return [
      SoundModel(
        filePath: 'fire.mp3',
        title: 'Fire',
        iconPath: 'assets/images/fire.jpg',
      ),
      SoundModel(
        filePath: 'river.mp3',
        title: 'River',
        iconPath: 'assets/images/river.jpg',
      ),
      SoundModel(
        filePath: 'waves.mp3',
        title: 'Waves',
        iconPath: 'assets/images/waves.jpg',
      ),
      SoundModel(
        filePath: 'forest.mp3',
        title: 'Forest',
        iconPath: 'assets/images/forest.jpg',
      ),
      SoundModel(
        filePath: 'city.mp3',
        title: 'City',
        iconPath: 'assets/images/city.jpg',
      ),
      SoundModel(
        filePath: 'ambient.mp3',
        title: 'Ambient',
        iconPath: 'assets/images/ambient1.jpg',
      ),
      SoundModel(
        filePath: 'tibet.mp3',
        title: 'Tibet',
        iconPath: 'assets/images/temple1.jpg',
      ),
      SoundModel(
        filePath: 'rain.mp3',
        title: 'Rain',
        iconPath: 'assets/images/rain.jpg',
      ),
      SoundModel(
        filePath: 'thunder.mp3',
        title: 'Thunder',
        iconPath: 'assets/images/thunder.jpg',
      ),
    ];
  }

  void _showAddSoundDialog(BuildContext context, PlaylistModel playlist) {
    final sounds = getAvailableSounds();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(
          child: Text(
            'Add Sound',
            style: AppStyles.popTitles,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: sounds.length,
            itemBuilder: (context, index) {
              final sound = sounds[index];
              return GestureDetector(
                onTap: () {
                  context.read<PlaylistBloc>().add(
                        AddSoundEvent(playlist.id, sound),
                      );
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          sound.iconPath ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.music_note, size: 40);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sound.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TimerBloc()),
      ],
      child: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoadedState) {
            final playlist = state.playlists.firstWhere(
              (pl) => pl.id == widget.playlistId,
              orElse: () => PlaylistModel(id: '', title: '', tracks: []),
            );

            if (playlist.id.isEmpty) {
              return const Scaffold(
                body: Center(child: Text('Playlist not found')),
              );
            }

            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(color: Color(0xFF6DA0E1)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Text(
                              playlist.title,
                              style: AppStyles.mixMain,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            left: 30,
                            child: Builder(
                              builder: (innerContext) => GestureDetector(
                                onTap: () async {
                                  await widget.audioHandler.stopAll();
                                  if (!innerContext.mounted) return;
                                  Navigator.of(innerContext).pop();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: AppStyles.secondaryAccent,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: playlist.tracks.length,
                            itemBuilder: (context, index) {
                              final sound = playlist.tracks[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppStyles.accentColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            const Color.fromARGB(100, 0, 0, 0),
                                        blurRadius: 7,
                                        offset: const Offset(2, 2),
                                      ),
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                            150, 255, 255, 255),
                                        blurRadius: 7,
                                        offset: const Offset(-2, -2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: PlayerWidget(
                                          key: ValueKey(sound.filePath),
                                          sound: sound,
                                          stopSignal: stopAll,
                                          audioHandler: widget.audioHandler,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      IconButton(
                                        style: AppStyles.smallButton,
                                        icon: const Icon(
                                          Icons.delete,
                                          color: AppStyles.secondaryAccent,
                                        ),
                                        onPressed: () {
                                          context.read<PlaylistBloc>().add(
                                              RemoveSoundEvent(
                                                  playlist.id, sound));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const ListFadeOverlay(
                              fadeColor: Color(0xFF6DA0E1), height: 15),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => _showAddSoundDialog(context, playlist),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
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
                        child: Text(
                          'Add Sound',
                          style: AppStyles.buttons,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TimerControlWidget(
                      onTimerComplete: () {
                        widget.audioHandler.stopAll();
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          } else if (state is PlaylistLoadedState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const Scaffold(
              body: Center(child: Text('Error loading playlist')),
            );
          }
        },
      ),
    );
  }
}
