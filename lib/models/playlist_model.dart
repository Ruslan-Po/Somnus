import 'package:somnus/models/sound_model.dart';

class PlaylistModel {
  final String id;
  final String title;
  final List<SoundModel> tracks;

  PlaylistModel({
    required this.id,
    required this.title,
    required this.tracks,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'tracks': tracks.map((t) => t.toJson()).toList(),
      };

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'],
      title: json['title'],
      tracks: (json['tracks'] as List)
          .map((trackJson) => SoundModel.fromJson(trackJson))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
