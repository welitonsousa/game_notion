import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/models/game_item_list_model.dart';

import 'cover_model.dart';

class GameSmallModel {
  final int id;
  final String name;
  final CoverModel? cover;
  List<int> state;

  GameSmallModel({
    required this.id,
    required this.name,
    required this.cover,
    required this.state,
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
    );

    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cover': cover?.toJson(),
      'state': state,
    };
  }
}
