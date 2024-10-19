import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

enum WindowManagerSize {
  ADMIN_SIZE,
  USER_SIZE,
}

class AppWindowManager {
  static AppWindowManager? _instance;

  WindowOptions windowOptions = const WindowOptions(
    title: "Control de Asistencia CCV",
    size: Size(800, 600),
    fullScreen: false,
    center: true,
    backgroundColor: Color(0xFFE5E5E5),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  static AppWindowManager getInstance() {
    _instance ??= AppWindowManager._();
    return _instance!;
  }

  AppWindowManager._();

  void init() async {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  void resizeWindow(WindowManagerSize state) async {
    if (state == WindowManagerSize.ADMIN_SIZE) {
      await windowManager.setSize(const Size(1200, 800), animate: true);
      await windowManager.setAlignment(Alignment.center);
    } else {
      await windowManager.setSize(const Size(800, 600), animate: true);
      await windowManager.setAlignment(Alignment.center);
    }
  }
}
