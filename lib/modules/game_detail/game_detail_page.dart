import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/core/extensions/string_ext.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/core/ui/widgets/app_error.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';
import 'package:game_notion/core/ui/widgets/app_loading.dart';
import 'package:game_notion/models/game_item_list_model.dart';
import 'package:game_notion/modules/game_detail/widgets/list_similar_games.dart';
import 'package:game_notion/modules/game_detail/widgets/screenshots_grid.dart';
import 'package:game_notion/modules/home/widgets/search_games_widget.dart';
import 'package:get/get.dart';
import 'package:search_select/search_select.dart';

import './game_detail_controller.dart';
import 'widgets/game_item_detail.dart';
import 'widgets/list_videos_widget.dart';
import 'widgets/platforms_widget.dart';

class GameDetailPage extends StatefulWidget {
  const GameDetailPage({super.key});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  late final GameDetailController controller;
  final yearController = TextEditingController();
  @override
  void initState() {
    final gameId = Get.parameters['id'];

    Get.put(
      tag: gameId,
      GameDetailController(
        gameService: Get.find(),
        homeController: Get.find(),
      ),
    );
    controller = Get.find<GameDetailController>(tag: gameId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const SearchGamesWidget(),
      appBar: AppBar(
        title: const Text('Detalhes do jogo'),
        // actions: [
        //   Obx(() {
        //     if (controller.game.value != null) {
        //       return FavoriteButtonWidget(
        //         state: controller.gameState,
        //         toggleFavorite: controller.toggleFavorite,
        //       );
        //     }
        //     return const SizedBox.shrink();
        //   })
        // ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const AppLoading();
        } else if (controller.error.value) {
          return AppError(onRetry: controller.findGame);
        }
        return ListView(
          children: [
            if (controller.game.value!.cover != null &&
                controller.game.value!.artworks.isEmpty)
              SizedBox(
                height: context.isPhone ? 500 : 300,
                child: GestureDetector(
                  onTap: () {
                    showImageViewer(
                      context,
                      AppImageCached.provider(
                          controller.game.value!.cover!.imageId.imageURL),
                      useSafeArea: true,
                      swipeDismissible: true,
                      immersive: true,
                    );
                  },
                  child: AppImageCached(
                    path: controller.game.value!.cover!.imageId.imageURL,
                    fit: context.isPhone ? BoxFit.cover : BoxFit.fitHeight,
                    width: double.infinity,
                  ),
                ),
              )
            else if (controller.game.value!.artworks.isNotEmpty)
              Stack(
                children: [
                  SizedBox(
                    child: GestureDetector(
                      onTap: () {
                        showImageViewer(
                          context,
                          AppImageCached.provider(controller
                              .game.value!.artworks.first.imageId.imageURL),
                          useSafeArea: true,
                          swipeDismissible: true,
                          immersive: true,
                        );
                      },
                      child: SizedBox(
                        height: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 300,
                              child: AppImageCached(
                                path: controller.game.value!.artworks.first
                                    .imageId.imageURL,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: GestureDetector(
                      onTap: () {
                        showImageViewer(
                          context,
                          AppImageCached.provider(
                              controller.game.value!.cover!.imageId.imageURL),
                          useSafeArea: true,
                          swipeDismissible: true,
                          immersive: true,
                        );
                      },
                      child: SizedBox(
                        height: 200,
                        width: 150,
                        child: Card(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AppImageCached(
                              path: controller
                                  .game.value!.cover!.imageId.imageURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(controller.game.value!.name,
                      style: const TextStyle(fontSize: 24)),
                  SearchSelect<GameItemListModel>(
                    selectedItems: controller.gameState ?? [],
                    onChange: controller.changeGameState,
                    label: 'Estado do jogo',
                    items: UserSettingsController.i.states,
                  ),
                  const SizedBox(height: 20),
                  SelectableText(
                    controller.game.value!.summary,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  PlatformsWidget(platforms: controller.game.value!.platforms),
                  const SizedBox(height: 20),
                  const Text(
                    'Jogos similares',
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  ListSimilarGames(
                    similarGames: controller.game.value!.similarGames,
                  ),
                  const SizedBox(height: 20),
                  GameItemDetail(
                    title: 'Capturas de tela',
                    child: ScreenshotsGridView(
                      screenshots: controller.game.value!.screenshots
                          .map((e) => e.imageId.imageURL)
                          .toList(),
                    ),
                  ),
                  GameItemDetail(
                    title: 'Vídeos',
                    child: ListVideosWidget(
                      videos: controller.game.value!.videos,
                    ),
                  ),
                  const SizedBox(height: 60)
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
