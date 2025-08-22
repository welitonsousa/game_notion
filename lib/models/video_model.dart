class VideoModel {
  final int id;
  final String name;
  final String videoID;

  VideoModel({
    required this.id,
    required this.name,
    required this.videoID,
  });

  factory VideoModel.fromJson(json) {
    return VideoModel(
      id: json['id'],
      name: json['name'] ?? '',
      videoID: json['video_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'videoID': videoID,
    };
  }
}
