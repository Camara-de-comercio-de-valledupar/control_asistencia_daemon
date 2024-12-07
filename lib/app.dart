import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huella Funcionario',
      home: const PushAlertLayer(child: SecurityLayer()),
      theme: primaryTheme,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldKey,
    );
  }
}

const snackbarColor = {
  PushAlertType.error: Color(0xFFD32F2F),
  PushAlertType.success: Color(0xFF388E3C),
  PushAlertType.warning: Color(0xFFE64A19),
  PushAlertType.info: Color(0xFF1976D2),
};
