import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_notion/remote/repositories/auth/auth_repository.dart';
import 'package:game_notion/remote/repositories/auth/auth_repository_impl.dart';
import 'package:game_notion/remote/services/auth/auth_service.dart';
import 'package:game_notion/remote/services/auth/auth_service_impl.dart';
import 'package:get/get.dart';
import './sign_up_controller.dart';

class SignUpBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthRepository>(AuthRepositoryImpl(auth: FirebaseAuth.instance));
    Get.put<AuthService>(AuthServiceImpl(authRepository: Get.find()));
    Get.put(SignUpController(authService: Get.find()));
  }
}
