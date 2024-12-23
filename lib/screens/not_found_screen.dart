import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Página no encontrada',
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.circleExclamation,
                size: 100, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 20),
            Text(
              "Página no encontrada",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
