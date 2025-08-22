import 'package:game_notion/models/game_item_list_model.dart';
import 'package:game_notion/models/game_model.dart';
import 'package:game_notion/modules/home/home_controller.dart';
import 'package:game_notion/remote/services/games/games_sevice.dart';
import 'package:get/get.dart';

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

  final loading = true.obs;
  final error = false.obs;

  Future<void> findGame() async {
    try {
      loading.value = true;
      game.value = await gameService.getGameById(id: gameId);
    } catch (e) {
      error.value = true;
    } finally {
      loading.value = false;
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

    game.value!.state = states.map((e) => e.id).toList();
    await gameService.saveGame(game: game.value!.toSmallModel());
  }
}
