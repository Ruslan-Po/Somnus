import 'package:somnus/models/sound_model.dart';

abstract class PlaylistEvent {}

class CreatePlaylistEvent extends PlaylistEvent {
  final String title;

  CreatePlaylistEvent(this.title);
}

class CreateDefoultPlaylist extends PlaylistEvent {
  CreateDefoultPlaylist();
}

class LoadPlaylistsEvent extends PlaylistEvent {}

class DeletePlaylistEvent extends PlaylistEvent {
  final String playlistId;

  DeletePlaylistEvent(this.playlistId);
}

class AddSoundEvent extends PlaylistEvent {
  final String playlistId;
  final SoundModel sound;

  AddSoundEvent(this.playlistId, this.sound);
}

class RemoveSoundEvent extends PlaylistEvent {
  final String playlistId;
  final SoundModel sound;

  RemoveSoundEvent(this.playlistId, this.sound);
}
