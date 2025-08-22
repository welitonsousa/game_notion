import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameItemDetail extends StatelessWidget {
  final String title;
  final Widget child;
  const GameItemDetail({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 22),
        ),
        initiallyExpanded: false,
        children: [child],
      ),
    );
  }
}
