import 'dart:developer';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityLayer extends StatelessWidget {
  const SecurityLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc()..add(AuthenticationStarted()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (kDebugMode) {
            log("AuthenticationBloc: $state");
          }
          if (state is AuthenticationInitial) {
            return const LoginScreen();
          }
          if (state is AuthenticationSuccess) {
            return const HomeScreen();
          }
          if (state is AuthenticationFailure) {
            return const LoginScreen();
          }
          if (state is AuthenticationInProgress) {
            return const LoadingScreen();
          }
          return const LoadingScreen();
        },
      ),
    );
  }
}
