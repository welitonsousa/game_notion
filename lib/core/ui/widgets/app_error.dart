import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppError extends StatelessWidget {
  final Function() onRetry;
  final String? message;
  const AppError({super.key, required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/bug.svg', width: 200, height: 200),
          const SizedBox(height: 20),
          if (message != null) ...[
            Text(message ?? 'Ops, algo deu errado'),
            const SizedBox(height: 10),
          ],
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
