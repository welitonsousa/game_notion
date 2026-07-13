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
import 'package:game_notion/core/ui/widgets/app_animate.dart';
import 'package:get/get.dart';
import 'package:search_select/search_select.dart';

import './game_detail_controller.dart';
import 'widgets/user_progress_widget.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: const SearchGamesWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
          shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1))],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [primaryColor.withValues(alpha: 0.1), Colors.black]
                : [primaryColor.withValues(alpha: 0.05), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.loading.value) {
            return const AppLoading();
          } else if (controller.error.value) {
            return AppError(onRetry: controller.findGame);
          }
          
          final game = controller.game.value!;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Hero Image Section
              Stack(
                children: [
                  // Banner (Artwork or Cover fallback)
                  if (game.artworks.isNotEmpty)
                    GestureDetector(
                      onTap: () => showImageViewer(
                        context,
                        AppImageCached.provider(game.artworks.first.imageId.imageURL),
                        useSafeArea: true,
                        swipeDismissible: true,
                        immersive: true,
                      ),
                      child: Container(
                        height: 380,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                              isDark ? Colors.black : Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.5, 0.8, 1.0],
                          ),
                        ),
                        child: AppImageCached(
                          path: game.artworks.first.imageId.imageURL,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    )
                  else if (game.cover != null)
                    GestureDetector(
                      onTap: () => showImageViewer(
                        context,
                        AppImageCached.provider(game.cover!.imageId.imageURL),
                        useSafeArea: true,
                        swipeDismissible: true,
                        immersive: true,
                      ),
                      child: Container(
                        height: context.isPhone ? 450 : 350,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.2),
                              isDark ? Colors.black : Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.6, 0.85, 1.0],
                          ),
                        ),
                        child: AppImageCached(
                          path: game.cover!.imageId.imageURL,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),

                  // Floating Cover
                  if (game.artworks.isNotEmpty && game.cover != null)
                    Positioned(
                      bottom: 0,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => showImageViewer(
                          context,
                          AppImageCached.provider(game.cover!.imageId.imageURL),
                          useSafeArea: true,
                          swipeDismissible: true,
                          immersive: true,
                        ),
                        child: Container(
                          height: 180,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 16,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AppImageCached(
                              path: game.cover!.imageId.imageURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              // Content Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAnimate(
                      type: AppAnimateType.fadeInUp,
                      delay: const Duration(milliseconds: 100),
                      child: SelectableText(
                        game.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    AppAnimate(
                      type: AppAnimateType.fadeInUp,
                      delay: const Duration(milliseconds: 150),
                      child: SearchSelect<GameItemListModel>(
                        selectedItems: controller.gameState ?? [],
                        onChange: controller.changeGameState,
                        label: 'Estado do jogo',
                        items: UserSettingsController.i.states,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    AppAnimate(
                      type: AppAnimateType.fadeInUp,
                      delay: const Duration(milliseconds: 180),
                      child: UserProgressWidget(controller: controller),
                    ),
                    const SizedBox(height: 32),
                    
                    if (game.summary.isNotEmpty) ...[
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 200),
                        child: const Text(
                          'Sobre',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 250),
                        child: SelectableText(
                          game.summary,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (game.platforms.isNotEmpty) ...[
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 300),
                        child: const Text(
                          'Plataformas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 350),
                        child: PlatformsWidget(platforms: game.platforms),
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (game.similarGames.isNotEmpty) ...[
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 400),
                        child: const Text(
                          'Jogos similares',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 450),
                        child: ListSimilarGames(
                          similarGames: game.similarGames,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (game.screenshots.isNotEmpty) ...[
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 500),
                        child: GameItemDetail(
                          title: 'Capturas de tela',
                          child: ScreenshotsGridView(
                            screenshots: game.screenshots
                                .map((e) => e.imageId.imageURL)
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    if (game.videos.isNotEmpty) ...[
                      AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        delay: const Duration(milliseconds: 550),
                        child: GameItemDetail(
                          title: 'Vídeos',
                          child: ListVideosWidget(
                            videos: game.videos,
                          ),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 80)
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
