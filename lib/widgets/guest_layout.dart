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
            leadingWidth: 200,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                "assets/logos/ccv.png",
              ),
            ),
            title: const Text('Control de Asistencia CCV'),
            actions: [
              if (state is AuthenticationSuccess)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.member.email),
                          Text(
                            "${state.member.firstName} ${state.member.lastName}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (state is! AuthenticationSuccess)
                Image.asset(
                  "assets/logos/gov.png",
                  width: 100,
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
