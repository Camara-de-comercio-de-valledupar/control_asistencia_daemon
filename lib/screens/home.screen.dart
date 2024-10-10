import 'dart:developer';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (kDebugMode) {
            log("DashboardBloc: $state");
          }
        },
        child: BlocProvider(
          create: (context) => AssistanceBloc(),
          child: BlocListener<AssistanceBloc, AssistanceState>(
            listener: (context, state) {
              if (state is AssistancePictureTaken) {
                BlocProvider.of<AssistanceBloc>(context).add(
                    AssistanceSendAssistanceRequest(state.picture,
                        BlocProvider.of<AuthenticationBloc>(context).token));
              }
              if (state is AssistanceRequestSent) {
                BlocProvider.of<PushAlertBloc>(context)
                    .add(const PushAlertBasicSuccess(
                  title: "Gracias! Has marcado tu asistencia",
                  body: "Ahora puedes continuar con tus labores",
                ));
              }
              if (state is AssistanceRequestFailed) {
                BlocProvider.of<PushAlertBloc>(context).add(
                  const PushAlertBasicError(
                    title: "Ups! Error al marcar asistencia",
                    body: "Ocurrió un error al marcar tu asistencia",
                  ),
                );
              }
            },
            child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
              Widget child = const LoadingScreen();
              if (state is DashboardInitial) {
                child = const DashboardScreen();
              }
              if (state is DashboardShowAssistanceView) {
                child = const DashboardScreen();
              }
              if (state is DashboardShowLoading) {
                child = const LoadingScreen();
              }
              if (state is DashboardShowAssistanceHistoryView) {
                child = const AssistanceHistoryScreen();
              }

              return DashboardLayout(
                child: child,
              );
            }),
          ),
        ),
      ),
    );
  }
}
