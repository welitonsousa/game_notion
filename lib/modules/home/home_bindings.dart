import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_notion/core/rest_client/rest_client.dart';
import 'package:game_notion/remote/repositories/games/games_repository.dart';
import 'package:game_notion/remote/repositories/games/games_repository_impl.dart';
import 'package:game_notion/remote/services/games/games_sevice.dart';
import 'package:game_notion/remote/services/games/games_sevice_impl.dart';
import 'package:get/get.dart';
import './home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(RestClient());
    Get.put<GameRepository>(GameRepositoryImpl(
      auth: FirebaseAuth.instance,
      storage: FirebaseFirestore.instance,
      restClient: Get.find(),
    ));
    Get.put<GameService>(GameServiceImpl(gameRepository: Get.find()));
    Get.put(HomeController(gameService: Get.find()));
  }
}
