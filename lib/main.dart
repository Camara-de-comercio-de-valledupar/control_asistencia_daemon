import 'dart:io';

import 'package:control_asistencia_daemon/firebase_options.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      title: "Control de Asistencia CCV",
      size: Size(800, 600),
      fullScreen: false,
      center: true,
      backgroundColor: Color(0xFFE5E5E5),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    await Firebase.initializeApp(
      name: "Control de Asistencia CCV",
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    runApp(const App());
  } else {
    throw UnsupportedError("This platform is not supported");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
