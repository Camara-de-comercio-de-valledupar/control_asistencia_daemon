import 'dart:developer';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final List<Role> roles;
  final List<Permission> permissions;
  const HomeScreen({super.key, required this.roles, required this.permissions});

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
          create: (context) => MyAssistanceBloc(),
          child: BlocListener<MyAssistanceBloc, MyAssistanceState>(
            listener: (context, state) {
              if (state is MyAssistancePictureTaken) {
                BlocProvider.of<MyAssistanceBloc>(context)
                    .add(MyAssistanceSendAssistanceRequest(
                  state.picture,
                ));
              }
              if (state is MyAssistanceRequestSent) {
                BlocProvider.of<PushAlertBloc>(context)
                    .add(const PushAlertBasicSuccess(
                  title: "Gracias! Has marcado tu asistencia",
                  body: "Ahora puedes continuar con tus labores",
                ));
                BlocProvider.of<DashboardBloc>(context)
                    .add(DashboardShowInitialViewRequested());
              }
              if (state is MyAssistanceRequestFailed) {
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
                child = DashboardScreen(
                  roles: roles,
                  permissions: permissions,
                );
              }
              if (state is DashboardShowTakeAssistanceView) {
                child = const TakeAssistanceScreen();
              }
              if (state is DashboardShowAssistanceStatisticsView) {
                child = const StatisticsScreen();
              }

              if (state is DashboardShowUserManagementView) {
                child = const UserManagementScreen();
              }

              if (state is DashboardShowAssistanceManagementView) {
                child = const AssistanceScreen();
              }

              if (state is DashboardShowStatisticsView) {
                child = const StatisticsScreen();
              }

              if (state is DashboardShowRoleManagementView) {
                child = const RoleManagementScreen();
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
