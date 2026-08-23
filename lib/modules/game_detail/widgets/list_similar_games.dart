import 'package:flutter/material.dart';
import 'package:game_notion/core/extensions/string_ext.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';
import 'package:game_notion/models/game_external_model.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';

class ListSimilarGames extends StatelessWidget {
  final List<ExternalGameModel> similarGames;
  const ListSimilarGames({super.key, required this.similarGames});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 12),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: similarGames.length,
      itemBuilder: (context, index) {
        final g = similarGames[index];
        return GestureDetector(
          onTap: () async {
            await Get.toNamed(
              '${AppPages.gameDetail}/${g.id}',
              arguments: g.id,
              preventDuplicates: false,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: g.cover != null
                      ? AppImageCached(
                          path: g.cover!.imageId.imageCoverURL,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.gamepad_outlined, color: Colors.white70),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 32,
                child: Text(
                  g.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
