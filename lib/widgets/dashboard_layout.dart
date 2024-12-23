import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardLayout extends StatelessWidget {
  final String title;
  final Widget child;
  const DashboardLayout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return GuestLayout(
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width > 600) const SideMenu(),
          Expanded(
            child: Column(
              children: [
                DashboardHeader(
                  title: title,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: child,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onPrimary;
    final Color backgroundColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: textColor, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: textColor, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.menu, color: textColor, size: 30),
                const SizedBox(width: 10),
                Text('Menú',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: textColor)),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final permissions = Get.find<AuthController>().permissions;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: permissions.length,
                itemBuilder: (context, index) {
                  final permission = permissions[index];
                  return ListTile(
                    title: Text(permission.item,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: textColor)),
                    onTap: () {
                      Get.toNamed(permission.url);
                    },
                  );
                },
              );
            }),
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
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
          width: 1,
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
