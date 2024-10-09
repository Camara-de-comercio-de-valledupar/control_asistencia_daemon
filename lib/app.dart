import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Asistencia CCV',
      home: const PushAlertLayer(child: SecurityLayer()),
      theme: primaryTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

const snackbarColor = {
  PushAlertType.error: Color(0xFFD32F2F),
  PushAlertType.success: Color(0xFF388E3C),
  PushAlertType.warning: Color(0xFFE64A19),
  PushAlertType.info: Color(0xFF1976D2),
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
            ScaffoldMessenger.of(context).clearSnackBars();
          }
          if (state is PushAlertReceived) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                key: const Key("push-alert"),
                content: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xFFF2F2F2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(state.pushAlert.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: snackbarColor[state.pushAlert.type],
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
