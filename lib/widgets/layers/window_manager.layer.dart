import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WindowManagerLayer extends StatelessWidget {
  final Widget child;
  const WindowManagerLayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WindowManagerCubit>(
      create: (context) => WindowManagerCubit(),
      child: BlocListener<WindowManagerCubit, WindowManagerState>(
        listener: (context, state) {
          if (state is WindowManagerResizedToAdmin) {
            AppWindowManager.getInstance().resizeWindow(
              WindowManagerSize.ADMIN_SIZE,
            );
          }
        },
        child: child,
      ),
    );
  }
}
