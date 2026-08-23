import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';

class ScreenshotsGridView extends StatefulWidget {
  final List<String> screenshots;
  const ScreenshotsGridView({super.key, required this.screenshots});

  @override
  State<ScreenshotsGridView> createState() => _ScreenshotsGridViewState();
}

class _ScreenshotsGridViewState extends State<ScreenshotsGridView> {
  static const _previewCount = 5;
  bool _expanded = false;

  void _openViewer(int index) {
    final providers = MultiImageProvider(
      initialIndex: index,
      widget.screenshots.map(AppImageCached.provider).toList(),
    );

    showImageViewerPager(
      context,
      providers,
      infinitelyScrollable: true,
      useSafeArea: true,
      swipeDismissible: true,
      immersive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenshots = widget.screenshots;
    final total = screenshots.length;
    final hasMore = total > _previewCount;
    final visibleCount = _expanded || !hasMore ? total : _previewCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 12),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 170,
              mainAxisExtent: 150,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: visibleCount,
            itemBuilder: (context, index) {
              final isLastPreviewTile =
                  !_expanded && hasMore && index == visibleCount - 1;
              return _MediaTile(
                imagePath: screenshots[index],
                onTap: isLastPreviewTile
                    ? () => setState(() => _expanded = true)
                    : () => _openViewer(index),
                overlay: isLastPreviewTile
                    ? Container(
                        color: Colors.black.withValues(alpha: 0.55),
                        alignment: Alignment.center,
                        child: Text(
                          '+${total - _previewCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
        if (_expanded && hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Center(
              child: TextButton.icon(
                onPressed: () => setState(() => _expanded = false),
                icon: const Icon(Icons.expand_less_rounded, size: 18),
                label: const Text('Mostrar menos'),
              ),
            ),
          ),
      ],
    );
  }
}

class _MediaTile extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;
  final Widget? overlay;

  const _MediaTile({required this.imagePath, required this.onTap, this.overlay});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.black26,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImageCached(path: imagePath, fit: BoxFit.cover),
                if (overlay != null) overlay!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
