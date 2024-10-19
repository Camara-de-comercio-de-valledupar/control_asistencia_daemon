import 'dart:io';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    initializeTimezone();
    await CacheService.init();
    AppWindowManager.getInstance().init();
  }
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
