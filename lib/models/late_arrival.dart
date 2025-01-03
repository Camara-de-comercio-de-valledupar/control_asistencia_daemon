// To parse this JSON data, do
//
//     final lateArrival = lateArrivalFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

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

// To parse this JSON data, do
//
//     final lateArrivalDetailItem = lateArrivalDetailItemFromJson(jsonString);

List<LateArrivalDetailItem> lateArrivalDetailItemFromJson(String str) =>
    List<LateArrivalDetailItem>.from(
        json.decode(str).map((x) => LateArrivalDetailItem.fromJson(x)));

String lateArrivalDetailItemToJson(List<LateArrivalDetailItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// ignore: must_be_immutable
class LateArrivalDetailItem extends Equatable {
  DateTime fecha;
  String hora;
  String nombre;

  LateArrivalDetailItem({
    required this.fecha,
    required this.hora,
    required this.nombre,
  });

  factory LateArrivalDetailItem.fromJson(Map<String, dynamic> json) =>
      LateArrivalDetailItem(
        fecha: DateTime.parse(json["fecha"]),
        hora: json["hora"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "hora": hora,
        "nombre": nombre,
      };

  String get dateFormatted => "${fecha.day}/${fecha.month}/${fecha.year}";
  // "0801" => "08:01 AM"
  String get hourFormatted {
    final hour = hora.substring(0, 2);
    final minute = hora.substring(2);
    return "$hour:$minute ${int.parse(hour) < 12 ? "AM" : "PM"}";
  }

  @override
  List<Object?> get props => [fecha, hora, nombre];
}
