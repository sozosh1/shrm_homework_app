import 'package:flutter/material.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/services/connectivity_service.dart';

class OfflineBanner extends StatelessWidget {
  final Widget child;

  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: getIt<ConnectivityService>().connectivityStream,
      initialData: true,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;

        return Column(
          children: [
            Expanded(child: child),
            if (!isConnected)
              Container(
                width: double.infinity,
                height: 30,
                color: Colors.redAccent,
                child: const Center(
                  child: Text(
                    'Offline mode',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
