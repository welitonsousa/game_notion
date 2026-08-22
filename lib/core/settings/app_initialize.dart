import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class AppInitialize {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Future.wait([
      FastCachedImageConfig.init(subDir: 'game_notion'),
      GetStorage.init('game_notion'),
    ]);
  }
}
