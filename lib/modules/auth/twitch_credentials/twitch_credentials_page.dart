
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_notion/core/settings/twitch_credentials_store.dart';
import 'package:game_notion/core/ui/app_message.dart';
import 'package:game_notion/core/ui/widgets/app_button.dart';
import 'package:game_notion/core/ui/widgets/app_form_field.dart';
import 'package:game_notion/routers/pages.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TwitchCredentialsPage extends StatefulWidget {
  const TwitchCredentialsPage({super.key});

  @override
  State<TwitchCredentialsPage> createState() => _TwitchCredentialsPageState();
}

class _TwitchCredentialsPageState extends State<TwitchCredentialsPage> {
  final form = GlobalKey<FormState>();
  final clientIdController = TextEditingController();
  final clientSecretController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    clientIdController.text = TwitchCredentialsStore.clientId() ?? '';
    clientSecretController.text = TwitchCredentialsStore.clientSecret() ?? '';
  }

  @override
  void dispose() {
    clientIdController.dispose();
    clientSecretController.dispose();
    super.dispose();
  }

  Future<void> _saveCredentials() async {
    if (!form.currentState!.validate()) {
      return;
    }

    setState(() => loading = true);

    try {
      await TwitchCredentialsStore.save(
        clientId: clientIdController.text,
        clientSecret: clientSecretController.text,
      );
      Get.offAllNamed(AppPages.signIn);
    } catch (_) {
      AppMessage.error('Não foi possível salvar as chaves');
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _openHelpLink() async {
    final opened = await launchUrlString(
      TwitchCredentialsStore.docsUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      AppMessage.error('Não foi possível abrir o link da Twitch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Twitch')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          Hero(
            tag: 'control',
            child: SvgPicture.asset('assets/images/logo.svg', height: 96),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Antes de continuar, informe suas credenciais da Twitch.',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Esses dados são salvos neste dispositivo e usados pelo app para acessar a API da Twitch.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        AppFormField(
                          label: 'TWITCH_CLIENT_ID',
                          controller: clientIdController,
                          textInputAction: TextInputAction.next,
                          validator: Zod().min(1).build,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),
                        AppFormField(
                          label: 'TWITCH_CLIENT_SECRET',
                          controller: clientSecretController,
                          textInputAction: TextInputAction.done,
                          validator: Zod().min(1).build,
                          textInputType: TextInputType.text,
                          isPassword: true,
                          onEditingComplete: _saveCredentials,
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Continuar',
                          loading: loading,
                          onPressed: _saveCredentials,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _openHelpLink,
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Onde obter essas chaves'),
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