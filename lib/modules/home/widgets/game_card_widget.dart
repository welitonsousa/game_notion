import 'package:flutter/material.dart';
import 'package:game_notion/core/extensions/string_ext.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';
import 'package:game_notion/models/game_small_model.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';

class GameCardWidget extends StatefulWidget {
  final GameSmallModel game;
  const GameCardWidget({super.key, required this.game});

  @override
  State<GameCardWidget> createState() => _GameCardWidgetState();
}

class _GameCardWidgetState extends State<GameCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Image / Fallback
            Positioned.fill(
              child: widget.game.cover != null
                  ? AppImageCached(
                      path: widget.game.cover!.imageId.imageCoverURL,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withValues(alpha: 0.4),
                            Theme.of(context).primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.gamepad_outlined,
                          size: 48,
                          color: Colors.white70,
                        ),
                      ),
                    ),
            ),
            // Dark gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            // Badges on Top
            if (widget.game.itemsList.isNotEmpty)
              Positioned(
                top: 10,
                right: 10,
                child: Wrap(
                  spacing: 4,
                  children: widget.game.itemsList.map((state) {
                    return Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 0.5),
                      ),
                      child: Icon(
                        state.icon,
                        size: 14,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            // Game Title
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.game.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Material Ripple effect for taps
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTapDown: (_) => _controller.forward(),
                  onTapUp: (_) => _controller.reverse(),
                  onTapCancel: () => _controller.reverse(),
                  onTap: () async {
                    await Get.toNamed(
                      '${AppPages.gameDetail}/${widget.game.id}',
                      arguments: widget.game.id,
                      preventDuplicates: false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
