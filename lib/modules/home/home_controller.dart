import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/models/game_item_list_model.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/modules/home/game_filters.dart';
import 'package:game_notion/remote/services/games/games_sevice.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GameService gameService;

  HomeController({required this.gameService});

  static const INITIAl_PAGE = 1;

  final isSearch = false.obs;
  final localFilter = ''.obs;
  final loading = true.obs;
  final settingsLoading = UserSettingsController.i.states.isEmpty.obs;
  final page = INITIAl_PAGE.obs;
  final pageViewController = PageController(initialPage: INITIAl_PAGE);
  final showFilters = false.obs;
  final filters = const GameFilters().obs;

  final allGames = <GameSmallModel>[].obs;

  List<String> get availableGenres {
    final set = <String>{};
    for (final g in allGames) {
      set.addAll(g.genres);
    }
    return set.toList()..sort();
  }

  List<String> get availablePlatforms {
    final set = <String>{};
    for (final g in allGames) {
      final platform = g.platformPlayed;
      if (platform != null && platform.isNotEmpty) set.add(platform);
    }
    return set.toList()..sort();
  }

  void clearFilters() {
    filters.value = const GameFilters();
    localFilter.value = '';
  }

  List<GameSmallModel> games(GameItemListModel state) {
    var list = allGames.where((g) {
      return g.state.contains(state.id);
    });
    list = list.where((g) {
      return g.name.toLowerCase().contains(localFilter.value.toLowerCase());
    });

    final f = filters.value;
    if (f.genres.isNotEmpty) {
      list = list.where((g) => g.genres.any(f.genres.contains));
    }
    if (f.platforms.isNotEmpty) {
      list = list.where((g) =>
          g.platformPlayed != null && f.platforms.contains(g.platformPlayed));
    }
    if (f.ratingRange != null) {
      list = list.where((g) =>
          g.userRating != null &&
          g.userRating! >= f.ratingRange!.start &&
          g.userRating! <= f.ratingRange!.end);
    }
    if (f.dateStartedRange != null) {
      list = list.where(
          (g) => g.dateStarted != null && _inDateRange(g.dateStarted!, f.dateStartedRange!));
    }
    if (f.dateFinishedRange != null) {
      list = list.where((g) =>
          g.dateFinished != null && _inDateRange(g.dateFinished!, f.dateFinishedRange!));
    }

    list = list.toList()..sort((a, b) => a.name.compareTo(b.name));
    return list.toList();
  }

  bool _inDateRange(DateTime date, DateTimeRange range) {
    final d = DateTime(date.year, date.month, date.day);
    final start = DateTime(range.start.year, range.start.month, range.start.day);
    final end = DateTime(range.end.year, range.end.month, range.end.day);
    return !d.isBefore(start) && !d.isAfter(end);
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

  Future<void> _ensureSettingsLoaded() async {
    if (UserSettingsController.i.states.isEmpty) {
      await UserSettingsController.getListStates();
    }
    settingsLoading.value = false;
  }

  @override
  void onReady() {
    openSteamGamesList();
    _ensureSettingsLoaded();
    super.onReady();
  }
}
