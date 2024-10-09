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

class DashboardLayout extends StatelessWidget {
  final Widget child;
  const DashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Column(
          children: [
            DashboardHeader(
              title: state.title,
              hasBackButton: state is! DashboardInitial,
            ),
            Expanded(
              child: child,
            ),
          ],
        );
      },
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final String title;
  final bool hasBackButton;
  const DashboardHeader(
      {super.key, required this.title, this.hasBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasBackButton)
            BackButton(
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                BlocProvider.of<DashboardBloc>(context)
                    .add(DashboardShowInitialViewRequested());
              },
            ),
          const Spacer(),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        ],
      ),
    );
  }
}
