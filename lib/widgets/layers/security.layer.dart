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
            Widget child = LoadingScreen();
            if (kDebugMode) {
              log("AuthenticationBloc: $state");
            }
            if (state is AuthenticationInitial) {
              child = LoginScreen();
            }
            if (state is AuthenticationSuccess) {
              child = HomeScreen(
                  roles: state.member.roles,
                  permissions: state.member.permissions);
            }
            if (state is AuthenticationInProgress) {
              child = LoadingScreen();
            }
            return GuestLayout(child: child);
          },
        ),
      ),
    );
  }
}
