import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  final String title;
  final Widget child;
  const DashboardLayout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return GuestLayout(
      child: Column(
        children: [
          DashboardHeader(
            title: title,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final String title;
  const DashboardHeader({super.key, required this.title});

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
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "v${AppConfig.version}",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
