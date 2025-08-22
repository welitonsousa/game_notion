import 'package:game_notion/models/cover_model.dart';
import 'package:game_notion/models/game_external_model.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/models/platform_model.dart';
import 'package:game_notion/models/video_model.dart';

class GameModel {
  final int id;
  final CoverModel? cover;
  final List<ExternalGameModel> similarGames;
  final String name;
  final List<PlatformModel> platforms;
  final List<CoverModel> screenshots;
  final String summary;
  final List<VideoModel> videos;
  final List<CoverModel> artworks;
  List<int> state;

  GameModel({
    required this.id,
    required this.similarGames,
    required this.name,
    required this.platforms,
    required this.screenshots,
    required this.summary,
    required this.videos,
    required this.artworks,
    this.cover,
    required this.state,
  });

  factory GameModel.fromJson(json) {
    final res = GameModel(
      id: json['id'],
      state: json['state'] != null ? List<int>.from(json['state']) : [],
      cover: json['cover'] != null ? CoverModel.fromJson(json['cover']) : null,
      similarGames: (json['similar_games'] ?? [])
          .map<ExternalGameModel>(ExternalGameModel.fromJson)
          .toList(),
      name: json['name'] ?? '',
      platforms: (json['platforms'] ?? [])
          .map<PlatformModel>(PlatformModel.fromJson)
          .toList(),
      screenshots: (json['screenshots'] ?? [])
          .map<CoverModel>(CoverModel.fromJson)
          .toList(),
      summary: json['summary'] ?? '',
      videos:
          (json['videos'] ?? []).map<VideoModel>(VideoModel.fromJson).toList(),
      artworks: (json['artworks'] ?? [])
          .map<CoverModel>(CoverModel.fromJson)
          .toList(),
    );

    return res;
  }

  GameSmallModel toSmallModel() {
    return GameSmallModel(
      id: id,
      cover: cover,
      name: name,
      state: state,
    );
  }
}
