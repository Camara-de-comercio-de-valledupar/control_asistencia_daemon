import 'package:control_asistencia_daemon/lib.dart';
import 'package:get/get.dart';

class AssistanceController extends GetxController {
  final Member member;

  // =================================================================

  AssistanceController({required this.member});

  // =================================================================

  final RxBool _loading = RxBool(false);

  // =================================================================

  bool get loading => _loading.value;

  // =================================================================

  final AssistanceService assistanceService = AssistanceService.getInstance();

  // =================================================================

  void markAssistance() async {
    _loading.value = true;
    final message = await assistanceService
        .createAssistance(memberId: member.id)
        .catchError(
      (error, stackTrace) {
        _loading.value = false;
      },
    );

    final content = messageByResponse(message);

    if (content["type"] == "warning") {
      Get.find<PushAlertController>().add(PushAlertError(
        title: content["title"]!,
        body: content["body"]!,
      ));
    } else {
      Get.find<PushAlertController>().add(PushAlertSuccess(
        title: content["title"]!,
        body: content["body"]!,
      ));
    }
    _loading.value = false;
  }
}

Map<String, String> messageByResponse(String response) {
  if (response.contains("Entrada")) {
    if (response.contains("Ya marco")) {
      if (response.contains("Mañana")) {
        return {
          "title": "Ups! Espera un momento",
          "body": "Ya marcaste tu entrada de la mañana",
          "type": "warning",
        };
      } else {
        return {
          "title": "Ups! Espera un momento",
          "body": "Ya marcaste tu entrada  de la tarde",
          "type": "warning",
        };
      }
    } else {
      if (response.contains("Mañana")) {
        return {
          "title": "¡Listo!",
          "body": "Entrada de la mañana marcada",
          "type": "success",
        };
      } else {
        return {
          "title": "¡Listo!",
          "body": "Entrada de la tarde marcada",
          "type": "success",
        };
      }
    }
  } else {
    if (response.contains("Ya marco")) {
      if (response.contains("Mañana")) {
        return {
          "title": "Ups! Espera un momento",
          "body": "Ya marcaste tu salida de la mañana",
          "type": "warning",
        };
      } else {
        return {
          "title": "Ups! Espera un momento",
          "body": "Ya marcaste tu salida de la tarde",
          "type": "warning",
        };
      }
    } else {
      if (response.contains("Mañana")) {
        return {
          "title": "¡Listo!",
          "body": "Salida de la mañana marcada",
          "type": "success",
        };
      } else {
        return {
          "title": "¡Listo!",
          "body": "Salida de la tarde marcada",
          "type": "success",
        };
      }
    }
  }
}
