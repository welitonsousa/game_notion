import 'package:game_notion/models/game_item_list_model.dart';
import 'package:game_notion/models/game_model.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/modules/home/home_controller.dart';
import 'package:game_notion/remote/services/games/games_sevice.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class GameDetailController extends GetxController {
  final GameService gameService;
  final HomeController homeController;
  GameDetailController({
    required this.gameService,
    required this.homeController,
  });

  late final int gameId;
  final game = Rxn<GameModel>();

  List<GameItemListModel>? get gameState {
    final index =
        homeController.allGames.indexWhere((e) => e.id == game.value?.id);
    if (index == -1) return null;
    return homeController.allGames[index].itemsList;
  }

  GameSmallModel getSavedModel() {
    final index = homeController.allGames.indexWhere((e) => e.id == gameId);
    if (index == -1) return game.value!.toSmallModel();

    final existing = homeController.allGames[index];
    if (existing.genres.isEmpty && (game.value?.genres.isNotEmpty ?? false)) {
      existing.genres = game.value!.genres;
    }
    return existing;
  }

  final loading = true.obs;
  final error = false.obs;
  final saving = false.obs;

  Future<void> findGame() async {
    try {
      loading.value = true;
      game.value = await gameService.getGameById(id: gameId);
      await _translateSummary();
    } catch (e) {
      error.value = true;
    } finally {
      loading.value = false;
    }
  }

  Future<void> _translateSummary() async {
    final currentGame = game.value;
    if (currentGame == null || currentGame.summary.isEmpty) return;

    final translated = await currentGame.summary.translate(to: 'pt');

    if (game.value?.id == currentGame.id) {
      game.value!.summary = translated.text;
      game.refresh();
    }
  }

  @override
  void onInit() {
    gameId = int.parse(Get.parameters['id']!);

    findGame();
    super.onInit();
  }

  Future<void> changeGameState(List<GameItemListModel> states) async {
    if (game.value == null) return;

    final existing = getSavedModel();
    existing.state = states.map((e) => e.id).toList();
    game.value!.state = existing.state;
    await _saveGame(existing);
  }

  Future<void> saveUserRating(double rating) async {
    if (game.value == null) return;
    final existing = getSavedModel();
    existing.userRating = rating;
    await _saveGame(existing);
  }

  Future<void> saveDateStarted(DateTime? date) async {
    if (game.value == null) return;
    final existing = getSavedModel();
    existing.dateStarted = date;
    await _saveGame(existing);
  }

  Future<void> saveDateFinished(DateTime? date) async {
    if (game.value == null) return;
    final existing = getSavedModel();
    existing.dateFinished = date;
    await _saveGame(existing);
  }

  Future<void> saveUserReview(String text) async {
    if (game.value == null) return;
    final existing = getSavedModel();
    existing.userReview = text.isEmpty ? null : text;
    await _saveGame(existing);
  }

  Future<void> savePlatformPlayed(String? platform) async {
    if (game.value == null) return;
    final existing = getSavedModel();
    existing.platformPlayed = platform;
    await _saveGame(existing);
  }

  Future<void> _saveGame(GameSmallModel game) async {
    saving.value = true;
    try {
      await gameService.saveGame(game: game);
    } finally {
      saving.value = false;
    }
  }
}
