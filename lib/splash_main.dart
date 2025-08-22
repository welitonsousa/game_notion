import 'package:fast_ui_kit/ui/theme/fast_theme.dart';
import 'package:flutter/material.dart';

class SplashMain extends StatelessWidget {
  final FastTheme theme;
  const SplashMain({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme.light,
      darkTheme: theme.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 200),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
