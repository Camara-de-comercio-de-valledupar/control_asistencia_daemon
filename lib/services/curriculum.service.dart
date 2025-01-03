import 'dart:convert';

import 'package:control_asistencia_daemon/lib.dart';

class CurriculumService {
  final HttpClient _client;
  static CurriculumService? _instance;

  CurriculumService(this._client);

  static CurriculumService getInstance() {
    _instance ??= CurriculumService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  Future<List<Curriculum>> getCurriculums() async {
    final response = await _client.get("/hojasdevidas");
    return curriculumFromJson(jsonEncode(response));
  }

  String? getCurriculumPhoto(String? photo) {
    if (photo != null) {
      return "https://appccvalledupar.co/timeittemporal/img/fotoshojadevida/$photo";
    }
    return null;
  }
}
