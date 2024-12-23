import 'package:control_asistencia_daemon/controllers/connection.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              color: Theme.of(context).colorScheme.primary,
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
            Center(
              child: Ink(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    Get.find<ConnectionController>().retry();
                  },
                  child: const Center(child: Icon(Icons.refresh, size: 50)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
