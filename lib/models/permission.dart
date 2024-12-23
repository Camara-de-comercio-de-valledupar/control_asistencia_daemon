// To parse this JSON data, do
//
//     final permission = permissionFromJson(jsonString);

List<Permission> permissionFromJson(List<dynamic> json) =>
    List<Permission>.from(json.map((x) => Permission.fromJson(x)));

class Permission {
  final int id;
  final String nombreCabecera;
  final String icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final List<Menu> menus;

  Permission({
    required this.id,
    required this.nombreCabecera,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.menus,
  });

  Permission copyWith({
    int? id,
    String? nombreCabecera,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    List<Menu>? menus,
  }) =>
      Permission(
        id: id ?? this.id,
        nombreCabecera: nombreCabecera ?? this.nombreCabecera,
        icon: icon ?? this.icon,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        menus: menus ?? this.menus,
      );

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json["id"],
        nombreCabecera: json["nombreCabecera"] ?? "",
        icon: json["icon"] ?? "fa fa-cogs",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        menus: List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreCabecera": nombreCabecera,
        "icon": icon,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
      };
}

class Menu {
  final int id;
  final int cabecerasId;
  final String item;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;

  Menu({
    required this.id,
    required this.cabecerasId,
    required this.item,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Menu copyWith({
    int? id,
    int? cabecerasId,
    String? item,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) =>
      Menu(
        id: id ?? this.id,
        cabecerasId: cabecerasId ?? this.cabecerasId,
        item: item ?? this.item,
        url: url ?? this.url,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        id: json["id"],
        cabecerasId: json["cabeceras_id"],
        item: json["item"],
        url: (json["url"] ?? "").replaceAll("#", ""),
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
