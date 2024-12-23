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
              child: FutureBuilder<Uint8List?>(
                  future: networkToUint8List(member.photo),
                  builder: (context, snapshot) {
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          snapshot.hasData ? MemoryImage(snapshot.data!) : null,
                      child: Builder(builder: (context) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: LoadingIndicator(
                              count: 1,
                              label: null,
                              size: 30,
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return const SizedBox();
                        }
                        return Icon(Icons.person, color: backgroundColor);
                      }),
                    );
                  }),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${member.firstName} ${member.lastName}",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: textColor),
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
