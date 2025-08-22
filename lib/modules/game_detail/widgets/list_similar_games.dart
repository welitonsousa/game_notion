import 'package:flutter/material.dart';
import 'package:game_notion/core/extensions/string_ext.dart';
import 'package:game_notion/models/game_external_model.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';

class ListSimilarGames extends StatefulWidget {
  final List<ExternalGameModel> similarGames;
  const ListSimilarGames({super.key, required this.similarGames});

  @override
  State<ListSimilarGames> createState() => _ListSimilarGamesState();
}

class _ListSimilarGamesState extends State<ListSimilarGames> {
  final scroll = ScrollController();

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Scrollbar(
        controller: scroll,
        thumbVisibility: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            controller: scroll,
            itemBuilder: (context, index) {
              final g = widget.similarGames[index];
              return GestureDetector(
                onTap: () async {
                  await Get.toNamed(
                    '${AppPages.gameDetail}/${g.id}',
                    arguments: g.id,
                    preventDuplicates: false,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (g.cover != null)
                        Image.network(
                          g.cover?.imageId.imageCoverURL ?? '',
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        g.name,
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: widget.similarGames.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}
