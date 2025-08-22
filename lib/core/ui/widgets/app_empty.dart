import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppEmpty extends StatelessWidget {
  final Function()? onRetry;
  final String? message;
  const AppEmpty({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/empty.svg',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          if (message != null) ...[
            Text(message!),
            const SizedBox(height: 10),
          ],
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Recarregar'),
            ),
        ],
      ),
    );
  }
}
