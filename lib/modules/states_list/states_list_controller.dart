import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/models/game_item_list_model.dart';
import 'package:get/get.dart';

class StatesListController extends GetxController {
  final user = UserSettingsController.i;

  final listGamesState = <GameItemListModel>[].obs;

  @override
  void onInit() {
    listGamesState.assignAll(user.settings.gameStates);
    super.onInit();
  }

  void reorderList(int oldIndex, int newIndex) {
    final item = listGamesState.removeAt(oldIndex);
    listGamesState.insert(newIndex, item);

    user.settings.gameStates = listGamesState;
    UserSettingsController.saveNewList(listGamesState);
  }

  Future<void> deleteItem(int id) async {
    listGamesState.removeWhere((element) => element.id == id);
    user.settings.gameStates = listGamesState;

    await UserSettingsController.saveNewList(listGamesState);
  }

  Future<void> addItem(GameItemListModel item) async {
    listGamesState.add(item);
    user.settings.gameStates = listGamesState;
    await UserSettingsController.saveNewList(listGamesState);
  }

  Future<void> updateItem(GameItemListModel item) async {
    final index = listGamesState.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      listGamesState[index] = item;
      user.settings.gameStates = listGamesState;
      await UserSettingsController.saveNewList(listGamesState);
    }
  }
}
