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
      return Scaffold(
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
        body: Visibility(
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
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 240,
                      mainAxisExtent: 240,
                    ),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return GameCardWidget(game: game);
                    },
                  ),
                );
              });
            },
          ),
          child: const AppLoading(),
        ),
        floatingActionButton: const SearchGamesWidget(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: SnakeNavigationBar.color(
            currentIndex: controller.page.value,
            showUnselectedLabels: context.isTablet,
            showSelectedLabels: context.isTablet,
            snakeViewColor: context.theme.buttonTheme.colorScheme?.primary,
            unselectedItemColor: context.theme.buttonTheme.colorScheme?.primary,
            snakeShape: SnakeShape.rectangle,
            onTap: (index) {
              controller.page.value = index;
              controller.pageViewController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
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
      );
    });
  }
}
