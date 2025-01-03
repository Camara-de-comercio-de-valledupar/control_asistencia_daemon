import 'dart:convert';

import 'package:control_asistencia_daemon/lib.dart';

class WorkPermitService {
  final HttpClient _client;
  static WorkPermitService? _instance;

  WorkPermitService._internal(this._client);

  factory WorkPermitService.getInstance() {
    _instance ??= WorkPermitService._internal(HttpClient.getInstance());
    return _instance!;
  }

  Future<List<WorkPermit>> getWorkPermits(
    int employeeId, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final startDateString = startDate.toIso8601String().substring(0, 10);
    final endDateString = endDate.toIso8601String().substring(0, 10);
    final response = await _client.get(
        "/DetallePermisosEmpleado/empleados_id/$employeeId/fechaInicio/$startDateString/fechaFin/$endDateString");
    return workPermitFromJson(jsonEncode(response["datos"]));
  }
}
