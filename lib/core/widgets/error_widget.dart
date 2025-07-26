import 'package:flutter/material.dart';
import 'package:shrm_homework_app/core/theme/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String retryButtonText;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryButtonText = 'Повторить',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.lightRedBackground,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, color: AppColors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(retryButtonText)),
        ],
      ),
    );
  }
}
