import 'dart:typed_data';

import 'package:control_asistencia_daemon/lib.dart';

class SendAssistanceRequest {
  final String token;
  final Uint8List picture;

  SendAssistanceRequest(this.token, this.picture);
}

class AssistanceService {
  static final AssistanceService instance = AssistanceService._internal();

  AssistanceService._internal();

  Future<void> sendAssistanceRequest(SendAssistanceRequest request) async {
    // Send the assistance request
    throw UnimplementedError();
  }

  Future<List<Assistance>> getAssistanceRequests() async {
    // Get the assistance requests
    throw UnimplementedError();
  }
}
