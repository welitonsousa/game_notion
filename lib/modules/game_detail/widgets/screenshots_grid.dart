import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';

class ScreenshotsGridView extends StatelessWidget {
  final List<String> screenshots;
  const ScreenshotsGridView({super.key, required this.screenshots});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 240,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final screenshot = screenshots[index];
        return GestureDetector(
          onTap: () {
            final providers = MultiImageProvider(
              initialIndex: index,
              screenshots.map((e) {
                return AppImageCached.provider(e);
              }).toList(),
            );

            showImageViewerPager(
              context,
              providers,
              infinitelyScrollable: true,
              useSafeArea: true,
              swipeDismissible: true,
              immersive: true,
            );
          },
          child: AppImageCached(
            path: screenshot,
            fit: BoxFit.cover,
          ),
        );
      },
      itemCount: screenshots.length,
    );
  }
}
