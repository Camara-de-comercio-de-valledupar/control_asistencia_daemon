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
    await assistanceService.createAssistance(memberId: member.id).catchError(
      (error, stackTrace) {
        _loading.value = false;
        throw error;
      },
    );
    _loading.value = false;
  }
}
