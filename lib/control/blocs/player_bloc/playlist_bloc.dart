import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somnus/control/audio_handler.dart';
import '../../../../models/playlist_model.dart';
import '../../../../models/sound_model.dart';
import 'playlist_events.dart';
import 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final List<PlaylistModel> _playlists = [];
  final LocalAudioHandler audioHandler;

  static const String _playlistsKey = 'playlists_key';

  PlaylistBloc(this.audioHandler) : super(PlaylistInitialState()) {
    on<LoadPlaylistsEvent>(_onLoadPlaylists);
    on<CreatePlaylistEvent>(_onCreatePlaylist);
    on<DeletePlaylistEvent>(_onDeletePlaylist);
    on<AddSoundEvent>(_onAddSound);
    on<RemoveSoundEvent>(_onRemoveSound);
    on<CreateDefoultPlaylist>(_initializeDefaultPlaylists);

    add(LoadPlaylistsEvent());
  }

  Future<void> _onLoadPlaylists(
      LoadPlaylistsEvent event, Emitter<PlaylistState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPlaylists = prefs.getString(_playlistsKey);

    _playlists.clear();

    if (savedPlaylists != null) {
      final List decodedList = jsonDecode(savedPlaylists);
      _playlists.addAll(
          decodedList.map((playlist) => PlaylistModel.fromJson(playlist)));
    } else {
      _playlists.addAll(_defaultPlaylists());
      await _savePlaylists();
    }

    emit(PlaylistLoadedState(List.from(_playlists)));
  }

  void _onCreatePlaylist(
      CreatePlaylistEvent event, Emitter<PlaylistState> emit) {
    final newPlaylist = PlaylistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title,
      tracks: [],
    );

    _playlists.add(newPlaylist);
    emit(PlaylistLoadedState(List.from(_playlists)));
    _savePlaylists();
  }

  void _onDeletePlaylist(
      DeletePlaylistEvent event, Emitter<PlaylistState> emit) {
    _playlists.removeWhere((pl) => pl.id == event.playlistId);
    emit(PlaylistLoadedState(List.from(_playlists)));
    _savePlaylists();
  }

  void _onAddSound(AddSoundEvent event, Emitter<PlaylistState> emit) {
    final playlist = _playlists.firstWhere((pl) => pl.id == event.playlistId);
    playlist.tracks.add(event.sound);
    emit(PlaylistLoadedState(List.from(_playlists)));
    _savePlaylists();
  }

  void _onRemoveSound(RemoveSoundEvent event, Emitter<PlaylistState> emit) {
    final playlist = _playlists.firstWhere((pl) => pl.id == event.playlistId);
    playlist.tracks.remove(event.sound);
    emit(PlaylistLoadedState(List.from(_playlists)));
    _savePlaylists();
    unawaited(audioHandler.stopSound(event.sound.filePath));
  }

  Future<void> _savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_playlists.map((pl) => pl.toJson()).toList());
    await prefs.setString(_playlistsKey, jsonString);
  }

  void _initializeDefaultPlaylists(
      CreateDefoultPlaylist event, Emitter<PlaylistState> emit) {
    _playlists.clear();
    _playlists.addAll(_defaultPlaylists());
    emit(PlaylistLoadedState(List.from(_playlists)));
    _savePlaylists();
  }

  List<PlaylistModel> _defaultPlaylists() {
    return [
      PlaylistModel(
        id: '1',
        title: 'Nature Mix',
        tracks: [
          SoundModel(
              filePath: 'nature.mp3',
              title: 'Forest',
              iconPath: 'assets/images/forest.jpg'),
          SoundModel(
              filePath: 'river.mp3',
              title: 'River',
              iconPath: 'assets/images/river.jpg'),
        ],
      ),
      PlaylistModel(
        id: '2',
        title: 'Fireplace/Beach',
        tracks: [
          SoundModel(
              filePath: 'fire.mp3',
              title: 'Fire',
              iconPath: 'assets/images/fire.jpg'),
          SoundModel(
              filePath: 'waves.mp3',
              title: 'Waves',
              iconPath: 'assets/images/waves.jpg'),
        ],
      ),
      PlaylistModel(
        id: '3',
        title: 'CityBeach',
        tracks: [
          SoundModel(
              filePath: 'waves.mp3',
              title: 'Waves',
              iconPath: 'assets/images/waves.jpg'),
          SoundModel(
              filePath: 'city.mp3',
              title: 'City',
              iconPath: 'assets/images/city.jpg'),
        ],
      ),
    ];
  }
}
