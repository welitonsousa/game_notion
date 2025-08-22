import 'package:fast_ui_kit/icons/icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_notion/core/settings/user_settings_controller.dart';
import 'package:game_notion/core/ui/dialogs/about_dialog.dart';
import 'package:game_notion/core/ui/dialogs/logout_dialog.dart';
import 'package:game_notion/models/settings_model.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final user = FirebaseAuth.instance.currentUser!;
  final storage = GetStorage();
  final userSettings = UserSettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              otherAccountsPictures: [
                SvgPicture.asset('assets/images/logo.svg')
              ],
              otherAccountsPicturesSize: const Size(60, 60),
              decoration: const BoxDecoration(color: Colors.transparent),
              accountName: Text(
                user.displayName ?? 'Usuário',
                style: TextStyle(
                  fontSize: 20,
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              accountEmail: Text(
                user.email ?? 'Email não disponível',
                style: TextStyle(
                  fontSize: 14,
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),
            ExpansionTile(
              title: const Text('Tema'),
              leading: Icon(FastIcons.awesome.pencil_square),
              children: List.generate(
                ThemeMode.values.length,
                (index) {
                  final theme = ThemeMode.values[index];
                  return ListTile(
                    selected: index == userSettings.settings.themeMode.index,
                    title: Text(switch (theme) {
                      ThemeMode.system => 'Sistema',
                      ThemeMode.light => 'Claro',
                      ThemeMode.dark => 'Escuro',
                    }),
                    onTap: () {
                      userSettings.changeThemeMode(theme);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            ExpansionTile(
                title: const Text('Cor do app'),
                leading: const Icon(Icons.palette),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        SettingsModel.colors.length,
                        (index) {
                          final color = SettingsModel.colors[index];
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(100),
                                border: userSettings.settings.themeColor ==
                                        color
                                    ? Border.all(
                                        width: 4,
                                        color: context.theme.colorScheme.primary
                                            .withOpacity(.5),
                                      )
                                    : null,
                              ),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onTap: () {
                              userSettings.changeThemeColor(color);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ]),
            ExpansionTile(
              title: const Text('Fonte'),
              leading: Icon(FastIcons.awesome.font),
              children: List.generate(
                SettingsModel.fonts.length,
                (index) {
                  final name = SettingsModel.fonts[index];
                  return ListTile(
                    selected: name == userSettings.settings.fontName,
                    title: Text(
                      name,
                      style: TextStyle(fontFamily: name),
                    ),
                    onTap: () {
                      userSettings.changeFont(name);
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(FastIcons.awesome.gamepad),
              title: const Text('Listas de games'),
              onTap: () async {
                Get.back();
                Get.toNamed(AppPages.StatesList);
              },
            ),
            ListTile(
              leading: Icon(FastIcons.awesome.user),
              title: const Text('Sobre'),
              onTap: () async {
                Get.back();
                showDialog(
                  context: context,
                  builder: (context) => const AppAboutDialog(),
                );
              },
            ),
            ListTile(
              leading: Icon(FastIcons.awesome.window_close),
              title: const Text('Sair'),
              onTap: () async {
                Get.back();
                showDialog(
                  context: context,
                  builder: (context) => const LogoutDialog(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
