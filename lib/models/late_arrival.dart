// To parse this JSON data, do
//
//     final lateArrival = lateArrivalFromJson(jsonString);

import 'dart:convert';

List<LateArrival> lateArrivalFromJson(String str) => List<LateArrival>.from(
    json.decode(str).map((x) => LateArrival.fromJson(x)));

String lateArrivalToJson(List<LateArrival> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LateArrival {
  int id;
  String nombres;
  String apellidos;
  String noDocumento;
  String nombreCargo;
  int cantidad;

  LateArrival({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.noDocumento,
    required this.nombreCargo,
    required this.cantidad,
  });

  factory LateArrival.fromJson(Map<String, dynamic> json) => LateArrival(
        id: json["id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        noDocumento: json["noDocumento"],
        nombreCargo: json["nombreCargo"],
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombres": nombres,
        "apellidos": apellidos,
        "noDocumento": noDocumento,
        "nombreCargo": nombreCargo,
        "cantidad": cantidad,
      };

  String get nombreCompleto => "$nombres $apellidos";
}
