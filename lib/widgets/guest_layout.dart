import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
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
    return AppBar(
        toolbarHeight: kToolbarHeight + 40,
        leadingWidth: MediaQuery.of(context).size.width < 600 ? 0 : 100,
        leading: const CustomBackButton(),
        title: Obx(
          () {
            final currentMember = Get.find<AuthController>().currentMember;
            return currentMember != null
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                            const SizedBox(height: 5),
                            Text('Control de asistencia',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                          ],
                        ),
                      ],
                    ),
                  );
          },
        ));
  }
}
