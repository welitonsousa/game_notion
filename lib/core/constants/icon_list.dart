import 'package:flutter/material.dart';
import 'package:material_symbols_icons/get.dart';

class IconModel {
  final IconData icon;
  final String name;

  IconModel({required this.icon, required this.name});

  @override
  String toString() {
    return name;
  }
}

final _iconsNames = [...SymbolsGet.values];

List<String> get listIcons {
  final listIcons = <String>[];
  final codes = <int>[];
  for (var e in _iconsNames) {
    final icon = SymbolsGet.get(e, SymbolStyle.outlined);
    if (!codes.contains(icon.codePoint)) {
      codes.add(icon.codePoint);
      listIcons.add(e);
    }
  }
  return listIcons;
}
