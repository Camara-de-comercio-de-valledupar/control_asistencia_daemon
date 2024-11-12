import 'dart:typed_data';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:dio/dio.dart';

class SendAssistanceRequest {
  final Uint8List picture;

  SendAssistanceRequest(this.picture);
}

class AssistanceService {
  final HttpClient _client;
  static AssistanceService? _instance;

  AssistanceService(this._client);

  static AssistanceService getInstance() {
    _instance ??= AssistanceService(HttpClient.getInstance());
    return _instance!;
  }

  Future<void> sendAssistanceRequest(SendAssistanceRequest request) async {
    final form = FormData.fromMap({
      "images": [
        MultipartFile.fromBytes(request.picture, filename: "picture.jpg")
      ],
    });
    await _client.post("/assistances/", form);
  }

  Future<List<Assistance>> getMyAssistance() async {
    final response = await _client.get<List>("/assistances/v2/");
    return response.map((e) => Assistance.fromJson(e)).toList();
  }

  Future<List<Assistance>> getAssistances() async {
    final response = await _client.get<List>("/assistances/v2/all/");
    return response.map((e) => Assistance.fromJson(e)).toList();
  }

  Future<List<AssistanceReport>> getAssistanceReports() async {
    final response = await _client.get<List>("/reports/json");
    return response.map((e) => AssistanceReport.fromJson(e)).toList();
  }
}
