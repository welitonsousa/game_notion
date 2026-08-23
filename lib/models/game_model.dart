import 'package:game_notion/models/cover_model.dart';
import 'package:game_notion/models/game_external_model.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/models/language_support_model.dart';
import 'package:game_notion/models/platform_model.dart';
import 'package:game_notion/models/time_to_beat_model.dart';
import 'package:game_notion/models/video_model.dart';

class GameModel {
  final int id;
  final CoverModel? cover;
  final List<ExternalGameModel> similarGames;
  final String name;
  final List<PlatformModel> platforms;
  final List<CoverModel> screenshots;
  String summary;
  final List<VideoModel> videos;
  final List<CoverModel> artworks;
  final DateTime? firstReleaseDate;
  final List<String> genres;
  final List<String> developers;
  final List<String> publishers;
  final List<String> gameModes;
  final double? rating;
  final double? aggregatedRating;
  final List<LanguageSupportModel> languageSupports;
  TimeToBeatModel? timeToBeat;
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
    this.firstReleaseDate,
    this.genres = const [],
    this.developers = const [],
    this.publishers = const [],
    this.gameModes = const [],
    this.rating,
    this.aggregatedRating,
    this.languageSupports = const [],
    this.timeToBeat,
  });

  factory GameModel.fromJson(json) {
    final involvedCompanies = (json['involved_companies'] ?? []) as List;

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
      firstReleaseDate: json['first_release_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['first_release_date'] as int) * 1000)
          : null,
      genres: ((json['genres'] ?? []) as List)
          .map<String>((e) => (e['name'] ?? '') as String)
          .where((e) => e.isNotEmpty)
          .toList(),
      developers: involvedCompanies
          .where((e) => e['developer'] == true && e['company'] != null)
          .map<String>((e) => (e['company']['name'] ?? '') as String)
          .where((e) => e.isNotEmpty)
          .toList(),
      publishers: involvedCompanies
          .where((e) => e['publisher'] == true && e['company'] != null)
          .map<String>((e) => (e['company']['name'] ?? '') as String)
          .where((e) => e.isNotEmpty)
          .toList(),
      gameModes: ((json['game_modes'] ?? []) as List)
          .map<String>((e) => (e['name'] ?? '') as String)
          .where((e) => e.isNotEmpty)
          .toList(),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      aggregatedRating: json['aggregated_rating'] != null
          ? (json['aggregated_rating'] as num).toDouble()
          : null,
      languageSupports: ((json['language_supports'] ?? []) as List)
          .map<LanguageSupportModel>((e) => LanguageSupportModel.fromJson(e))
          .where((e) => e.language.isNotEmpty && e.supportType.isNotEmpty)
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
      genres: genres,
    );
  }
}
