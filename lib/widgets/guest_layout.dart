import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class GuestLayout extends StatelessWidget {
  final Widget child;
  const GuestLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(child: child),
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Text("Versión ${AppConfig.version}",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onPrimary)),
                ))),
      ],
    );
  }

  AppBar _buildAppBar(context) {
    final currentMember = Get.find<AuthController>().currentMember;
    return AppBar(
      toolbarHeight: kToolbarHeight + 40,
      leadingWidth: 100,
      leading: Builder(
        builder: (context) {
          if (!Navigator.of(context).canPop()) {
            return const SizedBox.shrink();
          }
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const SizedBox(
                width: 100,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.chevronLeft),
                      SizedBox(width: 5),
                      Text("Atrás", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      title: currentMember != null
          ? UserTagMenu(member: currentMember)
          : Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Image.asset(
                    "assets/logos/logo.png",
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppConfig.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                      const SizedBox(height: 5),
                      Text('Control de asistencia',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
