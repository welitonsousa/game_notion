import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_notion/core/settings/app_initialize.dart';
import 'package:game_notion/core/settings/twitch_credentials_store.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';

import 'splash_main.dart';
 
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  runApp(SplashMain());
  await AppInitialize.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final settings = UserSettingsController.instance;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        if (Get.currentRoute != AppPages.home) {
          await UserSettingsController.initialize();
          Get.offAllNamed(AppPages.home);
        }
      } else {
        final nextRoute = TwitchCredentialsStore.hasSavedCredentials()
            ? AppPages.signIn
            : AppPages.twitchSetup;

        if (Get.currentRoute != nextRoute) {
          Get.offAllNamed(nextRoute);
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: UserSettingsController.instance,
        builder: (context, child) {
            final dark = ThemeData.dark(useMaterial3: true).copyWith(
              primaryColor: settings.settings.themeColor,
              textTheme: ThemeData.dark(useMaterial3: true).textTheme.apply(
                    fontFamily: settings.settings.fontName,
                  ),
            );
             final light = ThemeData.light(useMaterial3: true).copyWith(
              primaryColor: settings.settings.themeColor,
              textTheme: ThemeData.light(useMaterial3: true).textTheme.apply(
                    fontFamily: settings.settings.fontName,
                  ),
            );
          return GetMaterialApp(
            title: 'Game Notion',
            darkTheme: dark,
            theme: light,
            themeMode: settings.settings.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: TwitchCredentialsStore.hasSavedCredentials()
                ? AppPages.signIn
                : AppPages.twitchSetup,
            getPages: AppPages.pages,
          );
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
