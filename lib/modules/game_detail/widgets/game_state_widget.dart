import 'package:flutter/material.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/core/ui/widgets/app_animate.dart';
import 'package:game_notion/core/ui/widgets/app_button_group.dart';
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
    return AppAnimate(
      type: AppAnimateType.elasticInDown,
      duration: const Duration(seconds: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: AppButtonGroup<GameItemListModel>(
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
