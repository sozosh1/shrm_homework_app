import 'package:flutter/material.dart';
import 'package:shrm_homework_app/core/network/connectivity_service.dart';
import 'package:get_it/get_it.dart';

class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = GetIt.I<ConnectivityService>();

    return StreamBuilder<bool>(
      stream: connectivityService.connectionStream,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;
        if (isConnected) {
          return const SizedBox.shrink();
        }

        return Container(
          color: Colors.red,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Offline mode',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}