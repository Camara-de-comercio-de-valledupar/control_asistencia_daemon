import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off,
              size: 100.0,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Sin conexión a internet",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "Por favor, revisa tu conexión a internet e intenta de nuevo",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
