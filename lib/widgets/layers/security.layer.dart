import 'dart:developer';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const messages = {
  "es": {
    "unknown-error": {
      "title": "Error desconocido",
      "body": "Ocurrió un error desconocido. Por favor, intenta de nuevo.",
    },
    "invalid-credentials": {
      "title": "Credenciales inválidas",
      "body":
          "Las credenciales ingresadas son inválidas. Por favor, intenta de nuevo.",
    },
  }
};

class SecurityLayer extends StatelessWidget {
  const SecurityLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc()..add(AuthenticationStarted()),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationPreSuccess) {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(AuthenticationProfileFetched(state.token));
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            Widget child = const LoadingScreen();
            if (kDebugMode) {
              log("AuthenticationBloc: $state");
            }
            if (state is AuthenticationInitial) {
              child = const LoginScreen();
            }
            if (state is AuthenticationSuccess) {
              child = const HomeScreen(roles: [
                Role.USER,
              ], permissions: [
                Permission.CREATE_ASSISTANCE,
              ]);
            }
            if (state is AuthenticationInProgress) {
              child = const LoadingScreen();
            }
            return GuestLayout(child: child);
          },
        ),
      ),
    );
  }
}
