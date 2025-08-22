import 'package:flutter/material.dart';
import 'package:game_notion/core/extensions/string_ext.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';

class GameCardWidget extends StatelessWidget {
  final GameSmallModel game;
  const GameCardWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(
          '${AppPages.gameDetail}/${game.id}',
          arguments: game.id,
          preventDuplicates: false,
        );
      },
      child: Card(
        child: Column(
          children: [
            if (game.cover != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: AppImageCached(
                  path: game.cover!.imageId.imageCoverURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 160,
                ),
              )
            else
              const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                game.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
