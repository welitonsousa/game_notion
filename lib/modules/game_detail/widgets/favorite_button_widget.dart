import 'package:flutter/material.dart';
import 'package:game_notion/core/ui/widgets/app_animate.dart';
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
        icon: AppAnimate(
          duration: const Duration(milliseconds: 500),
          type: AppAnimateType.pulse,
          child: Icon(
            Icons.favorite,
            color: context.theme.buttonTheme.colorScheme?.primary,
          ),
        ),
      );
    } else {
      return IconButton(
        onPressed: toggleFavorite,
        icon: const Icon(Icons.favorite),
      );
    }
  }
}
