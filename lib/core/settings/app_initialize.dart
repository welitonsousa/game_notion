import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:game_notion/firebase_options.dart';
import 'package:get_storage/get_storage.dart';

class AppInitialize {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Future.wait([
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
      FastCachedImageConfig.init(),
      GetStorage.init(),
    ]);
  }
}
