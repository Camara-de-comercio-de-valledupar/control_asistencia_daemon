// To parse this JSON data, do
//
//     final permission = permissionFromJson(jsonString);

List<Permission> permissionFromJson(List<dynamic> json) =>
    List<Permission>.from(json.map((x) => Permission.fromJson(x)));

class Permission {
  final int id;
  final int cabecerasId;
  final String item;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  Permission({
    required this.id,
    required this.cabecerasId,
    required this.item,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Permission copyWith({
    int? id,
    int? cabecerasId,
    String? item,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) =>
      Permission(
        id: id ?? this.id,
        cabecerasId: cabecerasId ?? this.cabecerasId,
        item: item ?? this.item,
        url: url ?? this.url,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        cabecerasId: json["cabeceras_id"],
        item: json["item"],
        url: json["url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cabeceras_id": cabecerasId,
        "item": item,
        "url": url,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
