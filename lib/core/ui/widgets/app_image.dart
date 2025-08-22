import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageCached extends StatefulWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Widget? error;
  const AppImageCached({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.error,
  });

  @override
  State<AppImageCached> createState() => _AppImageCachedState();

  static FastCachedImageProvider provider(String url) =>
      FastCachedImageProvider(url);
}

class _AppImageCachedState extends State<AppImageCached> {
  @override
  Widget build(BuildContext context) {
    if (widget.path.isEmpty) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: widget.error,
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
        child: FastCachedImage(
          key: ValueKey(widget.path),
          url: widget.path,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
          isAntiAlias: true,
          filterQuality: FilterQuality.low,
          showErrorLog: false,
          errorBuilder: (_, __, ___) {
            return widget.error ?? const SizedBox();
          },
        ),
      ),
    );
  }
}
