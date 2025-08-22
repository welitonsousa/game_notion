import 'package:flutter/material.dart';
import 'package:game_notion/models/platform_model.dart';

class PlatformsWidget extends StatelessWidget {
  final List<PlatformModel> platforms;
  const PlatformsWidget({super.key, required this.platforms});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: platforms
          .map(
            (e) => Chip(
              label: Text(e.name),
            ),
          )
          .toList(),
    );
  }
}
