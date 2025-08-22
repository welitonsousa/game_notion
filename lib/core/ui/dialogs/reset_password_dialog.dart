import 'package:fast_ui_kit/extension/text.dart';
import 'package:fast_ui_kit/ui/widgets/button.dart';
import 'package:fast_ui_kit/ui/widgets/form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_notion/core/ui/app_message.dart';
import 'package:get/get.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({super.key});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
              Text('Esqueceu a senha?', style: context.H2),
              const SizedBox(height: 10),
              SvgPicture.asset(
                'assets/images/email.svg',
                height: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Você receberá um email com instruções para redefinir sua senha.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: FastFormField(
                  label: 'Email',
                  controller: emailController,
                  validator: Zod().email().build,
                  textInputType: TextInputType.emailAddress,
                ),
              ),
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
                      label: 'Enviar',
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text,
                            );
                            Get.back();
                            AppMessage.success('Email enviado com sucesso');
                          } catch (e) {
                            AppMessage.error('Não foi possível enviar o email');
                          }
                        }
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
