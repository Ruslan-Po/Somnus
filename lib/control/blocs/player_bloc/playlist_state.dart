import 'package:somnus/models/playlist_model.dart';

abstract class PlaylistState {}

class PlaylistInitialState extends PlaylistState {}

class PlaylistLoadedState extends PlaylistState {
  final List<PlaylistModel> playlists;
  PlaylistLoadedState(this.playlists);
}
