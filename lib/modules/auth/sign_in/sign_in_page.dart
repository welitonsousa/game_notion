import 'package:fast_ui_kit/ui/widgets/animate.dart';
import 'package:fast_ui_kit/ui/widgets/button.dart';
import 'package:fast_ui_kit/ui/widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_notion/core/ui/dialogs/reset_password_dialog.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';

import './sign_in_controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final form = GlobalKey<FormState>();

  final controller = Get.find<SignInController>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          FastAnimate(
            type: FastAnimateType.jelloIn,
            delay: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 2000),
            child: Hero(
              tag: 'control',
              child: SvgPicture.asset('assets/images/logo.svg', height: 100),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: form,
                    child: Column(
                      children: [
                        FastFormField(
                          label: 'E-mail',
                          validator: Zod().email().build,
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        FastFormField(
                          label: 'Senha',
                          validator: Zod().min(6).build,
                          controller: passwordController,
                          isPassword: true,
                          onEditingComplete: () {
                            if (form.currentState!.validate()) {
                              Get.focusScope?.unfocus();
                              controller.signIn(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          return FastButton(
                            label: 'Entrar',
                            loading: controller.loading.value,
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                Get.focusScope?.unfocus();
                                controller.signIn(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          );
                        }),
                        const SizedBox(height: 10),
                        FastButton(
                          label: 'Entrar com Google',
                          background: Colors.red,
                          loading: controller.loading.value,
                          onPressed: controller.signInWithGoogle,
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(AppPages.signUp),
                          child: const Text('Cadastrar'),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const ResetPasswordDialog(),
                            );
                          },
                          child: const Text('Esqueci minha senha'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
