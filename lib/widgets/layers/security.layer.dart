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
          if (state is AuthenticationFailure) {
            const lang = "es";
            final data = messages[lang]![state.message] ??
                messages[lang]!["unknown-error"]!;
            BlocProvider.of<PushAlertBloc>(context).add(PushAlertBasicError(
              title: data["title"]!,
              body: data["body"]!,
            ));
          }
        },
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
      ),
    );
  }
}
