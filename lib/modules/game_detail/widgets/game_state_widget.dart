import 'package:fast_ui_kit/fast_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/models/game_item_list_model.dart';

class GameStateWidget extends StatelessWidget {
  final Function(GameItemListModel) onChange;
  final GameItemListModel state;
  const GameStateWidget({
    super.key,
    required this.onChange,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return FastAnimate(
      type: FastAnimateType.elasticInDown,
      duration: const Duration(seconds: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FastButtonGroup<GameItemListModel>(
          callback: (v) {
            if (v.isNotEmpty) onChange(v.first);
          },
          allowEmpty: false,
          multiple: false,
          values: UserSettingsController.instance.settings.gameStates,
          initial: [state],
        ),
      ),
    );
  }
}
