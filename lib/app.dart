import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Asistencia CCV',
      home: const SecurityLayer(),
      theme: primaryTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
