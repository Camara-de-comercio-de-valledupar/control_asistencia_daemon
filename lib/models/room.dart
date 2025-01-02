import 'dart:convert';

List<Room> roomFromJsonString(String str) =>
    List<Room>.from(json.decode(str).map((x) => Room.fromJson(x)));

List<Room> roomFromJson(List<dynamic> json) =>
    List<Room>.from(json.map((x) => Room.fromJson(x)));

List<dynamic> roomToJson(List<Room> data) =>
    List<dynamic>.from(data.map((x) => x.toJson()));

String roomToJsonString(List<Room> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Room {
  final int id;
  final String nombresalon;
  final String ubicacion;
  final String? imagen;
  final int valormediodia;
  final int valordia;
  final int capacidad;
  final String descripcion;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<Imagen> imagenes;

  Room({
    required this.id,
    required this.nombresalon,
    required this.ubicacion,
    required this.imagen,
    required this.valormediodia,
    required this.valordia,
    required this.capacidad,
    required this.descripcion,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.imagenes,
  });

  Room copyWith({
    int? id,
    String? nombresalon,
    String? ubicacion,
    String? imagen,
    int? valormediodia,
    int? valordia,
    int? capacidad,
    String? descripcion,
    String? estado,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    List<Imagen>? imagenes,
  }) =>
      Room(
        id: id ?? this.id,
        nombresalon: nombresalon ?? this.nombresalon,
        ubicacion: ubicacion ?? this.ubicacion,
        imagen: imagen ?? this.imagen,
        valormediodia: valormediodia ?? this.valormediodia,
        valordia: valordia ?? this.valordia,
        capacidad: capacidad ?? this.capacidad,
        descripcion: descripcion ?? this.descripcion,
        estado: estado ?? this.estado,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        imagenes: imagenes ?? this.imagenes,
      );

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        nombresalon: json["nombresalon"],
        ubicacion: json["ubicacion"],
        imagen: json["imagen"],
        valormediodia: json["valormediodia"],
        valordia: json["valordia"],
        capacidad: json["capacidad"],
        descripcion: json["descripcion"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] != null
            ? DateTime.parse(json["deleted_at"])
            : null,
        imagenes:
            List<Imagen>.from(json["imagenes"].map((x) => Imagen.fromJson(x))),
      );

  bool get isDisabled => estado == "Deshabilitado";

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombresalon": nombresalon,
        "ubicacion": ubicacion,
        "imagen": imagen,
        "valormediodia": valormediodia,
        "valordia": valordia,
        "capacidad": capacidad,
        "descripcion": descripcion,
        "estado": estado,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
        "imagenes": List<dynamic>.from(imagenes.map((x) => x.toJson())),
      };
}

class Imagen {
  final int id;
  final String file;
  final int salonesImagenesId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Imagen({
    required this.id,
    required this.file,
    required this.salonesImagenesId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Imagen copyWith({
    int? id,
    String? file,
    int? salonesImagenesId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      Imagen(
        id: id ?? this.id,
        file: file ?? this.file,
        salonesImagenesId: salonesImagenesId ?? this.salonesImagenesId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory Imagen.fromJson(Map<String, dynamic> json) => Imagen(
        id: json["id"],
        file: json["file"],
        salonesImagenesId: json["salones_imagenes_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] != null
            ? DateTime.parse(json["deleted_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
        "salones_imagenes_id": salonesImagenesId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
