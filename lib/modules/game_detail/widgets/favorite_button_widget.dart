import 'package:fast_ui_kit/icons/icons.dart';
import 'package:fast_ui_kit/ui/widgets/animate.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/models/game_item_list_model.dart';
import 'package:get/get.dart';

class FavoriteButtonWidget extends StatelessWidget {
  final GameItemListModel? state;
  final Function() toggleFavorite;
  const FavoriteButtonWidget({
    super.key,
    required this.state,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (state != null) {
      return IconButton(
        onPressed: toggleFavorite,
        icon: FastAnimate(
          duration: const Duration(milliseconds: 500),
          type: FastAnimateType.pulse,
          child: Icon(
            FastIcons.awesome.heart,
            color: context.theme.buttonTheme.colorScheme?.primary,
          ),
        ),
      );
    } else {
      return IconButton(
        onPressed: toggleFavorite,
        icon: Icon(FastIcons.awesome.heart),
      );
    }
  }
}
