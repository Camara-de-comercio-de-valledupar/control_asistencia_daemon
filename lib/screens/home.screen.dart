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
        child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
          Widget child = const LoadingScreen();
          if (state is DashboardInitial) {
            child = const DashboardScreen();
          }
          if (state is DashboardShowAssistanceView) {
            child = const AssistanceScreen();
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
    );
  }
}
