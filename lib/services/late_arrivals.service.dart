import 'dart:convert';

import 'package:control_asistencia_daemon/lib.dart';

class LateArrivalsService {
  final HttpClient _client;
  static LateArrivalsService? _instance;

  LateArrivalsService(this._client);

  static LateArrivalsService getInstance() {
    _instance ??= LateArrivalsService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  Future<List<LateArrival>> getLateArrivals({
    required DateTime begin,
    required DateTime end,
  }) async {
    // Formatear como yyyy-MM-dd -> Ejemplo: 2022-10-10
    final beginDateString = begin.toIso8601String().substring(0, 10);
    final endDateString = end.toIso8601String().substring(0, 10);

    final response = await _client.get(
        "/GetReporteEntradasTarde/fechaInicio/$beginDateString/fechaFin/$endDateString");

    return lateArrivalFromJson(jsonEncode(response["datos"]));
  }

  Future<List<LateArrivalDetailItem>> getLateArrivalsByEmployee({
    required int employeeId,
    required DateTime begin,
    required DateTime end,
  }) async {
    final beginDateString = begin.toIso8601String().substring(0, 10);
    final endDateString = end.toIso8601String().substring(0, 10);
    final response = await _client.get(
        "/GetDetalleEntradasTarde/empleados_id/$employeeId/fechaInicio/$beginDateString/fechaFin/$endDateString");

    return lateArrivalDetailItemFromJson(jsonEncode(response["datos"]));
  }
}
