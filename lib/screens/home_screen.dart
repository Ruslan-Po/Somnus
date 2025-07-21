// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:somnus/control/audio_handler.dart';
import 'package:somnus/control/blocs/player_bloc/playlist_bloc.dart';
import 'package:somnus/control/blocs/player_bloc/playlist_events.dart';
import 'package:somnus/control/blocs/player_bloc/playlist_state.dart';
import 'package:somnus/models/playlist_model.dart';
import 'package:somnus/screens/playlist_screen.dart';
import 'package:somnus/style/positional.dart';
import 'package:somnus/style/styles.dart';

class HomeScreen extends StatelessWidget {
  final LocalAudioHandler audioHandler;
  const HomeScreen({
    super.key,
    required this.audioHandler,
  });

  void _tryCreatePlaylist(BuildContext context, List<PlaylistModel> playlists) {
    if (playlists.length >= 10) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            'Limit reached',
            style: AppStyles.popTitles,
          ),
          content: Text('You can create up to 10 playlists only.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    _createPlaylist(context);
  }

  void _createPlaylist(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CreatePlaylistDialog(
        onCreate: (title) {
          context.read<PlaylistBloc>().add(CreatePlaylistEvent(title));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppStyles.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Mixes', style: AppStyles.mainText),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: BlocBuilder<PlaylistBloc, PlaylistState>(
                      builder: (context, state) {
                        if (state is PlaylistLoadedState) {
                          final playlists = state.playlists;
                          if (playlists.isEmpty) {
                            return const Center(
                                child: Text('No playlists yet.'));
                          }

                          return Stack(
                            children: [
                              ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: playlists.length,
                                itemBuilder: (context, index) {
                                  final playlist = playlists[index];
                                  return Dismissible(
                                    key: ValueKey(playlist.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.delete,
                                          color: Colors.white, size: 30),
                                    ),
                                    onDismissed: (direction) {
                                      context.read<PlaylistBloc>().add(
                                          DeletePlaylistEvent(playlist.id));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            backgroundColor:
                                                AppStyles.secondaryAccent,
                                            content: Center(
                                              child: Text(
                                                'Playlist "${playlist.title}" deleted',
                                                style: GoogleFonts.heebo(
                                                    fontSize: 15,
                                                    color:
                                                        AppStyles.routhAccent),
                                              ),
                                            )),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppStyles.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                  100, 0, 0, 0),
                                              blurRadius: 7,
                                              offset: const Offset(2, 2),
                                            ),
                                            BoxShadow(
                                              color: const Color.fromARGB(
                                                  100, 255, 255, 255),
                                              blurRadius: 7,
                                              offset: const Offset(-2, -2),
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          title: Text(playlist.title,
                                              style: AppStyles.buttons),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xFF5b61b2),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PlaylistScreen(
                                                    playlistId: playlist.id,
                                                    audioHandler: audioHandler),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const ListFadeOverlay(
                                  fadeColor: Color(0xFF6DA0E1), height: 15),
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
              BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
                  if (state is PlaylistLoadedState) {
                    final playlists = state.playlists;
                    final isLimit = playlists.length >= 10;
                    return GestureDetector(
                      onTap: isLimit
                          ? null
                          : () => _tryCreatePlaylist(context, playlists),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isLimit ? Colors.grey : AppStyles.primaryColor,
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
                          isLimit ? 'Limit reached' : 'Create Mix',
                          style: AppStyles.buttons,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreatePlaylistDialog extends StatefulWidget {
  final void Function(String) onCreate;

  const CreatePlaylistDialog({super.key, required this.onCreate});

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppStyles.accentColor,
      title: Center(
        child: Text(
          'New Playlist',
          style: AppStyles.popTitles,
        ),
      ),
      content: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: const InputDecoration(hintText: 'Playlist name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _controller.text.trim();
            if (title.isNotEmpty) {
              widget.onCreate(title);
              Navigator.pop(context);
            }
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}
