import 'package:control_asistencia_daemon/lib.dart';
import 'package:get/get.dart';

class CurriculumController extends GetxController {
  // =======================================================

  final CurriculumService _curriculumService = CurriculumService.getInstance();
  final CacheService _cacheService = CacheService.getInstance();

  // =======================================================

  final RxList<Curriculum> _curriculums = <Curriculum>[].obs;
  final RxBool _loading = false.obs;

  // =======================================================

  @override
  void onInit() {
    super.onInit();
    _getCurriculums();
  }

  // =======================================================

  List<Curriculum> get curriculums => _curriculums;
  bool get loading => _curriculums.isEmpty;

  // =======================================================

  Future<void> _getCurriculums() async {
    _loading.value = true;
    try {
      final curriculumsString = _cacheService.getString("curriculums");
      if (curriculumsString != null) {
        final curriculums = curriculumFromJson(curriculumsString);
        _curriculums.value = curriculums;
      } else {
        final curriculums = await _curriculumService.getCurriculums();
        _curriculums.value = curriculums;
        _cacheService.setString("curriculums", curriculumToJson(curriculums));
      }
    } finally {
      _loading.value = false;
      _loading.refresh();
    }
  }

  // =======================================================

  void refreshCurriculums() async {
    _loading.value = true;
    try {
      final curriculums = await _curriculumService.getCurriculums();

      _curriculums.value = curriculums;
      _cacheService.setString("curriculums", curriculumToJson(curriculums));
    } finally {
      _loading.value = false;
    }
  }

  // =======================================================

  String getMemberImage(Member member) {
    final curriculum = _curriculums.firstWhere(
      (element) => element.empleadosId == member.id,
    );
    return _curriculumService.getCurriculumPhoto(curriculum.foto)!;
  }

  // =======================================================

  bool hasCurriculum(Member member) {
    return _curriculums.any((element) => element.empleadosId == member.id);
  }

  // =======================================================

  String? getLateArrivalImage(LateArrival e) {
    final hasCurriculum =
        _curriculums.any((element) => element.empleadosId == e.id);
    if (hasCurriculum) {
      final curriculum = _curriculums.firstWhere(
        (element) => element.empleadosId == e.id,
      );
      return _curriculumService.getCurriculumPhoto(curriculum.foto);
    }
    return null;
  }
}
