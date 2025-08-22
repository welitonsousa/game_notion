import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/models/game_item_list_model.dart';
import 'package:game_notion/models/settings_model.dart';
import 'package:get_storage/get_storage.dart';

class UserSettingsController extends ChangeNotifier {
  static UserSettingsController? _instance;
  UserSettingsController._();

  static UserSettingsController get instance =>
      _instance ??= UserSettingsController._();

  static UserSettingsController get i => instance;

  var settings = SettingsModel();

  static Future<SettingsModel> initialize() async {
    final res = GetStorage().read('settings');
    if (res != null) {
      instance.settings = SettingsModel.fromJson(res);
    }
    await getListStates();
    return instance.settings;
  }

  static Future<void> getListStates() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final firebase = FirebaseFirestore.instance;
    final res = await firebase.collection(uid!).doc('settings').get();
    final states = res.data()?['gameStates'] ?? [];
    final List<GameItemListModel> list = states.map<GameItemListModel>((e) {
      return GameItemListModel.fromJson(e);
    }).toList();
    i.settings.gameStates = list;
    if (list.isEmpty) {
      i.settings.gameStates = GameItemListModel.initial;
      saveNewList(GameItemListModel.initial);
    }
  }

  static Future<void> saveNewList(List<GameItemListModel> list) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final firebase = FirebaseFirestore.instance;
    await firebase.collection(uid!).doc('settings').set({
      'gameStates': list.map((e) => e.toJson()).toList(),
    });
  }

  List<GameItemListModel> get states => settings.gameStates;

  void save() {
    GetStorage().write('settings', settings.toJson());
    notifyListeners();
  }

  void changeThemeColor(Color color) {
    settings.themeColor = color;
    save();
  }

  // void changeGemeStates(List<GameState> states) {
  //   settings.gameStates = states;
  //   save();
  // }

  void changeThemeMode(ThemeMode mode) {
    settings.themeMode = mode;
    save();
  }

  void changeFont(String font) {
    settings.fontName = font;
    save();
  }
}
