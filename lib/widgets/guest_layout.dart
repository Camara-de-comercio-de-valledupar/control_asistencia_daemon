import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestLayout extends StatelessWidget {
  final Widget child;
  const GuestLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          appBar: AppBar(
            toolbarHeight: kToolbarHeight + 20,
            leadingWidth: 300,
            centerTitle: true,
            leading: Padding(
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
            actions: [
              if (state is AuthenticationSuccess)
                UserTagMenu(
                  member: state.member,
                ),
              const SizedBox(width: 20),
            ],
          ),
          body: Center(child: child),
        );
      },
    );
  }
}

class UserTagMenu extends StatefulWidget {
  final MemberAppCCvalledupar member;
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

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _focus = true;
        });
      },
      onExit: (_) {
        setState(() {
          _focus = false;
        });
      },
      child: PopupMenuButton(
        offset: const Offset(0, 70),
        tooltip: "Menú de usuario",
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationLogoutRequested());
                },
              ),
            ),
          ];
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: textColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: backgroundColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              if (!isMobile)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(widget.member.email,
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .bodyMedium
                    //         ?.copyWith(color: textColor)),
                    Text(
                      "${widget.member.firstName} ${widget.member.lastName}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
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
              const SizedBox(width: 10),
              Icon(Icons.arrow_drop_down_circle_sharp, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
