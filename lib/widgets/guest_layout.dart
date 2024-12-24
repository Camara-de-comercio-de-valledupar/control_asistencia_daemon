import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class GuestLayout extends StatelessWidget {
  final Widget child;
  const GuestLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final currentMember = Get.find<AuthController>().currentMember;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 40,
        leadingWidth: 100,
        leading: Builder(
          builder: (context) {
            if (!(Get.routing.isBack ?? false)) {
              return const SizedBox.shrink();
            }
            return GestureDetector(
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
              ),
      ),
      body: Stack(
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
      ),
    );
  }
}

class UserTagMenu extends StatelessWidget {
  final Member member;
  const UserTagMenu({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.secondary;
    final Color textColor = Theme.of(context).colorScheme.onSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: textColor,
            ),
            child: Center(
              child: CachingImage(
                url: member.photo ?? "",
                width: 60,
                height: 60,
                borderRadius: 30,
                fit: BoxFit.cover,
                errorWidget: Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.solidUser,
                        color: backgroundColor,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${member.firstName} ${member.lastName}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: textColor, overflow: TextOverflow.ellipsis),
                ),
                Text(
                  member.jonRole,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor),
                )
              ],
            ),
          ),
          PopupMenuButton(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: textColor,
                ),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: backgroundColor,
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Cerrar sesión'),
                      onTap: () {
                        Get.find<AuthController>().logout();
                      },
                    ),
                  ),
                ];
              }),
        ],
      ),
    );
  }
}
