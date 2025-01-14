import 'dart:convert';

import 'package:control_asistencia_daemon/lib.dart';

class WarehouseReportService {
  final HttpClient _client;
  static WarehouseReportService? _instance;

  WarehouseReportService(this._client);

  static WarehouseReportService getInstance() {
    _instance ??= WarehouseReportService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  Future<List<WarehouseReport>> getWarehouseReports({required int year}) async {
    final response = await _client.get("/reporte_almacen/$year");
    return warehouseReportFromJson(jsonEncode(response["datos"]));
  }
}
