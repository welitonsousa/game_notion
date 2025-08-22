import 'package:fast_ui_kit/ui/widgets/button.dart';
import 'package:fast_ui_kit/ui/widgets/form_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_notion/core/ui/app_state.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends AppState<SignUpPage, SignUpController> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();
  final form = GlobalKey<FormState>();

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
    password2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastre sua conta')),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Hero(
            tag: 'control',
            child: SvgPicture.asset('assets/images/logo.svg', height: 100),
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
                          textInputAction: TextInputAction.next,
                          validator: Zod().email().build,
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        FastFormField(
                          label: 'Senha',
                          textInputAction: TextInputAction.next,
                          validator: Zod().min(6).build,
                          controller: passwordController,
                          isPassword: true,
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 10),
                        FastFormField(
                          label: 'Confirme a senha',
                          validator: Zod()
                              .min(6)
                              .custom(
                                  (p) =>
                                      passwordController.text ==
                                      password2Controller.text,
                                  errorMessage: 'As senhas não conferem')
                              .build,
                          controller: password2Controller,
                          isPassword: true,
                          textInputType: TextInputType.emailAddress,
                          onEditingComplete: () {
                            if (form.currentState!.validate()) {
                              Get.focusScope?.unfocus();
                              controller.signUp(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          return FastButton(
                            label: 'Cadastrar',
                            loading: controller.loading.value,
                            onPressed: () {
                              if (form.currentState!.validate()) {
                                Get.focusScope?.unfocus();
                                controller.signUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          );
                        }),
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
