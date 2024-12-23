import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Huella Funcionario',
      theme: primaryTheme,
      getPages: [
        GetPage(name: "/login", page: () => const LoginScreen()),
        GetPage(
            name: "/dashboard",
            page: () => const DashboardScreen(),
            binding: BindingsBuilder(() {
              var currentMember = Get.find<AuthController>().currentMember;
              if (currentMember != null) {
                Get.put(AssistanceController(member: currentMember));
              }
            })),
        GetPage(name: "/", page: () => const LoadingScreen()),
        GetPage(name: "/offline", page: () => const OfflineScreen()),
      ],
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        configureDio();
        Get.lazyPut(() => PushAlertController());
        Get.put(AuthController());
        Get.put(ConnectionController());
      }),
    );
  }
}

const snackbarColor = {
  PushAlertType.error: Color(0xFFD32F2F),
  PushAlertType.success: Color(0xFF388E3C),
  PushAlertType.warning: Color(0xFFE64A19),
  PushAlertType.info: Color(0xFF1976D2),
};
