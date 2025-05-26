class SoundModel {
  final String filePath;
  final String title;
  final String? iconPath;
  SoundModel({
    required this.filePath,
    required this.title,
    this.iconPath,
  });

  factory SoundModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['iconPath'];

    final iconPath = rawPath != null && !rawPath.startsWith('assets/')
        ? 'assets/images/$rawPath'
        : rawPath;

    return SoundModel(
      filePath: json['filePath'],
      title: json['title'],
      iconPath: iconPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'title': title,
        if (iconPath != null)
          'iconPath': iconPath!.replaceFirst('assets/images/', ''),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundModel &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          title == other.title &&
          iconPath == other.iconPath;

  @override
  int get hashCode =>
      filePath.hashCode ^ title.hashCode ^ (iconPath?.hashCode ?? 0);
}
