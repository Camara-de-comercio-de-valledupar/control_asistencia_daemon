import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TakeAssistanceScreen extends StatelessWidget {
  const TakeAssistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCamera(context),
        const SizedBox(height: 20),
        _buildCustomCardButton(
          context,
          "Marcar asistencia",
          Icons.camera_alt,
          () {
            BlocProvider.of<MyAssistanceBloc>(context).add(
              const MyAssistanceTakeAPicture(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCamera(BuildContext context) {
    return SizedBox(
      width: 480,
      height: 360,
      child: CameraView(
        onCameraControllerLoaded: (value) {
          BlocProvider.of<MyAssistanceBloc>(context)
              .add(MyAssistanceLoadCameraController(value));
        },
      ),
    );
  }

  Widget _buildCustomCardButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 300,
      child: CustomCardButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 30, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          )),
    );
  }
}
