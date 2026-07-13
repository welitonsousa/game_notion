import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/models/game_item_list_model.dart';

import 'cover_model.dart';

class GameSmallModel {
  final int id;
  final String name;
  final CoverModel? cover;
  List<int> state;
  double? userRating;
  DateTime? dateStarted;
  DateTime? dateFinished;
  String? userReview;
  String? platformPlayed;

  GameSmallModel({
    required this.id,
    required this.name,
    required this.cover,
    required this.state,
    this.userRating,
    this.dateStarted,
    this.dateFinished,
    this.userReview,
    this.platformPlayed,
  });

  List<GameItemListModel> get itemsList {
    final list = UserSettingsController.i.settings.gameStates;
    return list.where((e) => state.contains(e.id)).toList();
  }

  factory GameSmallModel.fromJson(json) {
    dynamic state = json['state'] ?? [];
    if (state is int) {
      state = [state];
    }
    final res = GameSmallModel(
      id: json['id'],
      name: json['name'] ?? '',
      state: state.map<int>((e) => e as int).toList(),
      cover: json['cover'] != null ? CoverModel.fromJson(json['cover']) : null,
      userRating: json['userRating'] != null ? (json['userRating'] as num).toDouble() : null,
      dateStarted: json['dateStarted'] != null ? DateTime.parse(json['dateStarted']) : null,
      dateFinished: json['dateFinished'] != null ? DateTime.parse(json['dateFinished']) : null,
      userReview: json['userReview'],
      platformPlayed: json['platformPlayed'],
    );

    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cover': cover?.toJson(),
      'state': state,
      if (userRating != null) 'userRating': userRating,
      if (dateStarted != null) 'dateStarted': dateStarted!.toIso8601String(),
      if (dateFinished != null) 'dateFinished': dateFinished!.toIso8601String(),
      if (userReview != null) 'userReview': userReview,
      if (platformPlayed != null) 'platformPlayed': platformPlayed,
    };
  }
}
