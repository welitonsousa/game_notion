import 'package:flutter/material.dart';
import 'package:game_notion/core/extensions/string_ext.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';
import 'package:game_notion/models/video_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ListVideosWidget extends StatelessWidget {
  final List<VideoModel> videos;
  const ListVideosWidget({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 440,
        mainAxisExtent: 240,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final v = videos[index];
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: GestureDetector(
            onTap: () {
              final url = v.videoID.ytURL;
              launchUrlString(url, mode: LaunchMode.externalApplication);
            },
            child: Stack(
              children: [
                AppImageCached(
                  path: v.videoID.ytThumbURL,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      v.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
