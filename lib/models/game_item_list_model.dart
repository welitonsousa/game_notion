import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class GameItemListModel {
  final int id;
  final String name;
  final String? fontFamily;
  final String? fontPackage;
  final IconData icon;
  GameItemListModel({
    required this.id,
    required this.name,
    required this.icon,
    this.fontPackage,
    this.fontFamily = 'MaterialIcons',
  });

  factory GameItemListModel.fromJson(json) {
    return GameItemListModel(
      id: json['id'] as int,
      name: json['name'] as String,
      fontFamily: json['fontFamily'] as String,
      icon: IconData(
        json['icon'] as int,
        fontPackage: json['fontPackage'] as String,
        fontFamily: json['fontFamily'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'fontPackage': icon.fontPackage,
      'fontFamily': icon.fontFamily,
    };
  }

  static List<GameItemListModel> initial = [
    GameItemListModel(id: 0, name: 'Jogando', icon: Symbols.stadia_controller),
    GameItemListModel(id: 1, name: 'Zerado', icon: Symbols.verified),
    GameItemListModel(id: 3, name: 'Platinado', icon: Symbols.emoji_events),
    GameItemListModel(id: 2, name: 'Lista de Desejos', icon: Symbols.favorite),
    GameItemListModel(id: 4, name: 'Parado', icon: Symbols.access_time_filled),
  ];

  @override
  String toString() {
    return name;
  }
}
