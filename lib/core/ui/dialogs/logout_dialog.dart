import 'package:fast_ui_kit/extension/text.dart';
import 'package:fast_ui_kit/ui/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              Text('Logout', style: context.H2),
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
                    child: FastButton(
                      label: 'Cancelar',
                      background: context.theme.colorScheme.error,
                      onPressed: Get.back,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FastButton(
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
