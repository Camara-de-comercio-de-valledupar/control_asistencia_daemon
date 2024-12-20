import 'package:control_asistencia_daemon/lib.dart';

class AssistanceService {
  final HttpClient _client;
  static AssistanceService? _instance;

  AssistanceService(this._client);

  static AssistanceService getInstance() {
    _instance ??= AssistanceService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  Future<String> createAssistance({
    required int memberId,
  }) async {
    final response = await _client.post<String>("/storeEntradaSalida", {
      "Empleados_id": memberId,
    });

    return response;
  }
}
