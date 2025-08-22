import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:fast_ui_kit/fast_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_notion/core/ui/app_message.dart';
import 'package:game_notion/core/ui/widgets/app_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Game Notion',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showImageViewer(
                      context,
                      AppImageCached.provider(
                           'https://github.com/welitonsousa.png'),
                      useSafeArea: true,
                      swipeDismissible: true,
                      immersive: true,
                    );
                },
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      'https://github.com/welitonsousa.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  launchUrlString(
                    'https://welitonsousa.vercel.app',
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Desenvolvido por Weliton Sousa',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: context.theme.colorScheme.primary),
                  ),
                ),
              ),
              const Divider(),
              const ListTile(
                title: Text('Me pague um café para manter o app funcionando'),
              ),
              ListTile(
                  onTap: () {
                    Clipboard.setData(const ClipboardData(
                        text: '6cdf3ee5-f41c-452a-9cf1-a7f47f56db71'));
                    AppMessage.success('Copiado para a área de transferência');
                  },
                  title: const Text(
                    '6cdf3ee5-f41c-452a-9cf1-a7f47f56db71',
                  ),
                  subtitle: const Text('Toque para copiar o PIX')),
              const SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
