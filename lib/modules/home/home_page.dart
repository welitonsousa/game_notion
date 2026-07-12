import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/core/ui/app_state.dart';
import 'package:game_notion/core/ui/widgets/app_app_bar.dart';
import 'package:game_notion/core/ui/widgets/app_drawer.dart';
import 'package:game_notion/core/ui/widgets/app_empty.dart';
import 'package:game_notion/core/ui/widgets/app_loading.dart';
import 'package:game_notion/modules/home/widgets/game_card_widget.dart';
import 'package:game_notion/modules/home/widgets/search_games_widget.dart';
import 'package:game_notion/core/ui/widgets/app_animate.dart';
import 'package:get/get.dart';

import './home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AppState<HomePage, HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = UserSettingsController.i.states[controller.page.value];
      final label = state.name;
      final title = '$label (${controller.games(state).length})';
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final primaryColor = Theme.of(context).primaryColor;
      return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        onDrawerChanged: (isOpened) {
          setState(() {});
        },
        drawer: const AppDrawer(),
        appBar: AppAppBar(
          title: title,
          onSearch: (v) {
            setState(() {
              controller.localFilter(v);
            });
          },
          hint: 'Pesquisar jogos salvos',
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      primaryColor.withValues(alpha: 0.08),
                      Colors.black,
                    ]
                  : [
                      primaryColor.withValues(alpha: 0.05),
                      Colors.white,
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Visibility(
          visible: controller.loading.value,
          replacement: PageView.builder(
            itemCount:
                UserSettingsController.instance.settings.gameStates.length,
            onPageChanged: (value) {
              controller.page.value = value;
            },
            controller: controller.pageViewController,
            itemBuilder: (c, i) {
              final state =
                  UserSettingsController.instance.settings.gameStates[i];
              return Obx(() {
                final games = controller.games(state);
                return Visibility(
                  visible: controller.games(state).isNotEmpty,
                  replacement: const AppEmpty(),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: kToolbarHeight + 40, bottom: 120),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 260,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return AppAnimate(
                        type: AppAnimateType.fadeInUp,
                        duration: const Duration(milliseconds: 300),
                        delay: Duration(milliseconds: (index % 8) * 50),
                        child: GameCardWidget(game: game),
                      );
                    },
                  ),
                );
              });
            },
          ),
          child: const AppLoading(),
        ),
        ), // <-- close Container
        floatingActionButton: const SearchGamesWidget(),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.cardColor.withValues(alpha: 0.85),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),
              child: SnakeNavigationBar.color(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: controller.page.value,
               shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Adjust radius here
    ),
                showUnselectedLabels: true,
                showSelectedLabels: false,
                snakeViewColor: context.theme.primaryColor,
                unselectedItemColor: context.theme.unselectedWidgetColor,
                selectedItemColor: context.theme.unselectedWidgetColor,
                // snakeShape: SnakeShape.rectangle,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onTap: (index) {
                  controller.page.value = index;
                  controller.pageViewController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
                items: UserSettingsController.instance.settings.gameStates.map((e) {
                  return BottomNavigationBarItem(
                    icon: Icon(e.icon),
                    label: e.name,
                    tooltip: e.name,
                    
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    });
  }
}
