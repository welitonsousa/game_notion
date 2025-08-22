import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_notion/core/settings/env.dart';
import 'package:game_notion/core/ui/app_message.dart';
import 'package:game_notion/firebase_options.dart';
import 'package:game_notion/remote/services/auth/auth_service.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';

class SignInController extends GetxController {
  final AuthService authService;

  SignInController({required this.authService});
  final loading = false.obs;

  Future<void> signIn({required String email, required String password}) async {
    try {
      loading.value = true;
      await authService.signIn(email: email, password: password);
      Get.offAndToNamed(AppPages.home);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        AppMessage.error('Senha inválida');
      } else if (e.code == 'user-not-found') {
        AppMessage.error('Usuário não cadastrado');
      } else if (e.code == 'too-many-requests') {
        AppMessage.error('Muitas tentativas de login');
      } else {
        AppMessage.error('Não foi possível realizar o login');
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    late GoogleSignIn google;
    final clientID = DefaultFirebaseOptions.currentPlatform.iosClientId;
    // print('client id $clientID');
    const appID = Env.OAUTH_CLIENT_ID;

    if (Platform.isWindows) {
      await GoogleSignInDart.register(clientId: appID);
      google = GoogleSignIn();
    } else if (Platform.isAndroid) {
      google = GoogleSignIn();
    } else if (Platform.isIOS) {
      google = GoogleSignIn(clientId: clientID);
    }
    await Future.wait([
      google.signOut(),
      FirebaseAuth.instance.signOut(),
    ]);

    final res = await google.signIn();
    final googleAuth = await res?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.offAndToNamed(AppPages.home);
  }
}

String generateNonce({int length = 32}) {
  const characters =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();

  return List.generate(
    length,
    (_) => characters[random.nextInt(characters.length)],
  ).join();
}

class GoogleSignInArgs {
  final String clientId;
  final String scope;
  final String responseType;
  final String prompt;
  final String nonce;
  final String redirectUri;

  const GoogleSignInArgs({
    required this.clientId,
    required this.nonce,
    required this.redirectUri,
    required this.scope,
    required this.responseType,
    required this.prompt,
  });
}
