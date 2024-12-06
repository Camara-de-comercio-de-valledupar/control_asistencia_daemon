import 'package:control_asistencia_daemon/lib.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
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
          const SizedBox(width: 16),
          const VersionTag(),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }
}

class VersionTag extends StatelessWidget {
  const VersionTag({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Dio().get(
            "https://api.github.com/repos/jrdeavila/control_asistencia_daemon/releases/latest.json"),
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "versión ${snapshot.data?.data['tag_name'] ?? "0.0.0"}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          );
        });
  }
}
