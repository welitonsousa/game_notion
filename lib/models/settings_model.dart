import 'package:flutter/material.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/models/game_item_list_model.dart';

class SettingsModel {
  Color themeColor;
  ThemeMode themeMode;
  String fontName;
  List<GameItemListModel> gameStates;

  SettingsModel({
    this.themeColor = Colors.deepPurple,
    this.themeMode = ThemeMode.system,
    this.fontName = 'Inter',
    this.gameStates = const [],
  });

  toJson() {
    return {
      'themeColor': themeColor.value,
      'themeMode': themeMode.index,
      'fontName': fontName,
      'gameStates': UserSettingsController.i.states,
    };
  }

  static List<String> get fonts => [
        'Inter',
        'Comfortaa',
        'Roboto',
        'Oswald',
        'Lato',
        'Ubuntu',
      ];

  static SettingsModel fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      themeColor: Color(json['themeColor']),
      themeMode: ThemeMode.values[json['themeMode']],
      fontName: json['fontName'],
    );
  }

  static List<Color> get colors => [
        Colors.deepPurple,
        Colors.blue,
        Colors.red,
        Colors.green,
        Colors.orange,
        Colors.pink,
        Colors.purple,
        Colors.teal,
        Colors.amber,
        Colors.cyan,
        Colors.indigo,
        Colors.lime,
        Colors.brown,
        Colors.grey,
        Colors.blueGrey,
      ];
}
