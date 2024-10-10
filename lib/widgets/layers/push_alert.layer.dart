import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

const alertIconByType = {
  PushAlertType.error: Icons.error,
  PushAlertType.success: Icons.check_circle,
  PushAlertType.warning: Icons.warning,
  PushAlertType.info: Icons.info,
};

class PushAlertLayer extends StatelessWidget {
  final Widget child;
  const PushAlertLayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PushAlertBloc>(
      create: (context) => PushAlertBloc(),
      child: BlocListener<PushAlertBloc, PushAlertState>(
        listener: (context, state) {
          if (state is PushAlertInitial) {
            scaffoldKey.currentState?.hideCurrentSnackBar();
          }
          if (state is PushAlertReceived) {
            scaffoldKey.currentState?.showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                key: const Key("push-alert"),
                content: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: const Color(0xFFF2F2F2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 12,
                              spreadRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ]),
                      child: Row(
                        children: [
                          Icon(
                              alertIconByType[state.pushAlert.type] ??
                                  Icons.info,
                              color: snackbarColor[state.pushAlert.type]),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.pushAlert.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: snackbarColor[
                                              state.pushAlert.type],
                                        )),
                                Text(state.pushAlert.body,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headlineLarge
                                              ?.color,
                                        )),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                duration: const Duration(seconds: 3),
                dismissDirection: DismissDirection.startToEnd,
              ),
            );
          }
        },
        child: child,
      ),
    );
  }
}
