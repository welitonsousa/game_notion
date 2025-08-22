import 'package:game_notion/core/ui/app_message.dart';
import 'package:game_notion/remote/services/auth/auth_service.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final AuthService authService;

  SignUpController({required this.authService});
  final loading = false.obs;

  Future<void> signUp({required String email, required String password}) async {
    try {
      loading.value = true;
      await authService.signUp(email: email, password: password);
      Get.back();
      Get.offAndToNamed(AppPages.home);
    } catch (e) {
      AppMessage.error('Algo deu errado');
    } finally {
      loading.value = false;
    }
  }
}
