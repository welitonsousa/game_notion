import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final int starCount;
  final ValueChanged<double> onRatingChanged;

  const StarRatingWidget({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starCount = 5,
    this.size = 32,
  });

  IconData _iconFor(int index) {
    final diff = rating - index;
    if (diff >= 1) return Icons.star_rounded;
    if (diff >= 0.5) return Icons.star_half_rounded;
    return Icons.star_border_rounded;
  }

  void _handleTapDown(int index, TapDownDetails details) {
    final isFirstHalf = details.localPosition.dx < size / 2;
    final value = index + (isFirstHalf ? 0.5 : 1.0);
    onRatingChanged(value.clamp(0.5, starCount.toDouble()));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => _handleTapDown(index, details),
            child: Icon(
              _iconFor(index),
              size: size,
              color: Colors.amber,
            ),
          ),
        );
      }),
    );
  }
}
