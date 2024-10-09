import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class AssistanceScreen extends StatelessWidget {
  const AssistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: CameraView()),
      ],
    );
  }
}
