import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_notion/core/ui/widgets/app_button.dart';
import 'package:get/get.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Logout', style: context.theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              SvgPicture.asset(
                'assets/images/ps4-control.svg',
                height: 150,
              ),
              const SizedBox(height: 10),
              const Text('Você realmente deseja fazer logout do app?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Cancelar',
                      background: context.theme.colorScheme.error,
                      onPressed: Get.back,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'Logout',
                      onPressed: () async {
                        Get.back();
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
