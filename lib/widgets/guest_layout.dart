import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
        leadingWidth: double.infinity,
        centerTitle: true,
        leading: currentMember != null
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
                        Text('Huella Funcionario',
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
      body: Center(child: child),
    );
  }
}

class UserTagMenu extends StatefulWidget {
  final Member member;
  const UserTagMenu({
    super.key,
    required this.member,
  });

  @override
  State<UserTagMenu> createState() => _UserTagMenuState();
}

class _UserTagMenuState extends State<UserTagMenu> {
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final Color backgroundColor = !_focus
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onPrimary;
    final Color textColor = !_focus
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.primary;

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
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.member.photo ?? ""),
                onBackgroundImageError: (exception, stackTrace) {
                  if (kDebugMode) {
                    print(stackTrace);
                  }
                },
                child: widget.member.photo == null
                    ? Icon(Icons.person,
                        color: Theme.of(context).colorScheme.onPrimary)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (!isMobile)
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.member.firstName} ${widget.member.lastName}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: textColor),
                ),
                Text(
                  widget.member.jonRole,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor),
                )
              ],
            ),
          const Spacer(),
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
