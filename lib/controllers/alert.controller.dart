import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PushAlertType { error, success, warning, info }

class PushAlert {
  final String title;
  final String body;
  final PushAlertType type;

  PushAlert({
    required this.title,
    required this.body,
    required this.type,
  });
}

class PushAlertError extends PushAlert {
  PushAlertError({
    required super.title,
    required super.body,
  }) : super(
          type: PushAlertType.error,
        );
}

class PushAlertSuccess extends PushAlert {
  PushAlertSuccess({
    required super.title,
    required super.body,
  }) : super(
          type: PushAlertType.success,
        );
}

const alertIconByType = {
  PushAlertType.error: Icons.error,
  PushAlertType.success: Icons.check_circle,
  PushAlertType.warning: Icons.warning,
  PushAlertType.info: Icons.info,
};

class PushAlertController extends GetxController {
  // =================================================================

  void add(PushAlert alert) {
    if (kDebugMode) {
      print("PushAlertController.add -> ${alert.title}");
    }
    Get.snackbar(
      alert.title,
      alert.body,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      icon: Icon(
        alertIconByType[alert.type] ?? Icons.info,
        color: snackbarColor[alert.type],
        size: 30,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          spreadRadius: 2,
        )
      ],
      margin: EdgeInsets.only(
          bottom: 20, left: (Get.width > 600 ? 270 : 20), right: 20),
      padding: const EdgeInsets.all(10),
      borderRadius: 0,
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: false,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // =================================================================
}
