import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_notion/models/game_item_list_model.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/remote/services/games/games_sevice.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GameService gameService;

  HomeController({required this.gameService});

  static const INITIAl_PAGE = 1;

  final isSearch = false.obs;
  final localFilter = ''.obs;
  final loading = true.obs;
  final page = INITIAl_PAGE.obs;
  final pageViewController = PageController(initialPage: INITIAl_PAGE);

  final allGames = <GameSmallModel>[].obs;
  List<GameSmallModel> games(GameItemListModel state) {
    var list = allGames.where((g) {
      return g.state.contains(state.id);
    });
    list = list.where((g) {
      return g.name.toLowerCase().contains(localFilter.value.toLowerCase());
    });
    list = list.toList()..sort((a, b) => a.name.compareTo(b.name));
    return list.toList();
  }

  Future<List<GameSmallModel>> searchGames({required String q}) async {
    if (q.trim().isEmpty) return [];

    try {
      return await gameService.searchGames(q: q);
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  void openSteamGamesList() {
    final s = gameService.gamesStream();
    s?.listen((g) {
      allGames.assignAll(g.nonNulls);
      loading.value = false;
    });
  }

  @override
  void onReady() {
    openSteamGamesList();
    super.onReady();
  }
}
