// To parse this JSON data, do
//
//     final warehouseReport = warehouseReportFromJson(jsonString);

import 'dart:convert';

List<WarehouseReport> warehouseReportFromJson(String str) =>
    List<WarehouseReport>.from(
        json.decode(str).map((x) => WarehouseReport.fromJson(x)));

String warehouseReportToJson(List<WarehouseReport> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WarehouseReport {
  int solicitudId;
  String estado;
  String descripcion;
  DateTime fechaSolicitud;
  int anho;
  int mes;
  int dia;
  String producto;
  int cantidad;
  String unidad;
  String? satisfaccion;
  String funcionario;
  String cargo;
  String area;

  WarehouseReport({
    required this.solicitudId,
    required this.estado,
    required this.descripcion,
    required this.fechaSolicitud,
    required this.anho,
    required this.mes,
    required this.dia,
    required this.producto,
    required this.cantidad,
    required this.unidad,
    required this.satisfaccion,
    required this.funcionario,
    required this.cargo,
    required this.area,
  });

  factory WarehouseReport.fromJson(Map<String, dynamic> json) =>
      WarehouseReport(
        solicitudId: json["solicitud_id"],
        estado: json["estado"],
        descripcion: json["descripcion"],
        fechaSolicitud: DateTime.parse(json["fecha_solicitud"]),
        anho: json["año"],
        mes: json["mes"],
        dia: json["dia"],
        producto: json["producto"],
        cantidad: json["cantidad"],
        unidad: json["unidad"],
        satisfaccion: json["satisfaccion"],
        funcionario: json["funcionario"],
        cargo: json["cargo"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "solicitud_id": solicitudId,
        "estado": estado,
        "descripcion": descripcion,
        "fecha_solicitud":
            "${fechaSolicitud.year.toString().padLeft(4, '0')}-${fechaSolicitud.month.toString().padLeft(2, '0')}-${fechaSolicitud.day.toString().padLeft(2, '0')}",
        "año": anho,
        "mes": mes,
        "dia": dia,
        "producto": producto,
        "cantidad": cantidad,
        "unidad": unidad,
        "satisfaccion": satisfaccion,
        "funcionario": funcionario,
        "cargo": cargo,
        "area": area,
      };
}
