class Assistance {
  final int id;
  final int userId;
  final DateTime createdAt;
  final List<Evidence> images;

  Assistance({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.images,
  });

  Assistance copyWith({
    int? id,
    int? userId,
    DateTime? createdAt,
    List<Evidence>? images,
  }) =>
      Assistance(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        images: images ?? this.images,
      );

  factory Assistance.fromJson(Map<String, dynamic> json) => Assistance(
        id: json["id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        images: List<Evidence>.from(
            json["images"].map((x) => Evidence.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class Evidence {
  final int id;
  final String url;
  final String alt;
  final String title;
  final int width;
  final int height;
  final int size;
  final String mimeType;
  final DateTime createdAt;

  Evidence({
    required this.id,
    required this.url,
    required this.alt,
    required this.title,
    required this.width,
    required this.height,
    required this.size,
    required this.mimeType,
    required this.createdAt,
  });

  Evidence copyWith({
    int? id,
    String? url,
    String? alt,
    String? title,
    int? width,
    int? height,
    int? size,
    String? mimeType,
    DateTime? createdAt,
  }) =>
      Evidence(
        id: id ?? this.id,
        url: url ?? this.url,
        alt: alt ?? this.alt,
        title: title ?? this.title,
        width: width ?? this.width,
        height: height ?? this.height,
        size: size ?? this.size,
        mimeType: mimeType ?? this.mimeType,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Evidence.fromJson(Map<String, dynamic> json) => Evidence(
        id: json["id"],
        url: json["url"],
        alt: json["alt"],
        title: json["title"],
        width: json["width"],
        height: json["height"],
        size: json["size"],
        mimeType: json["mime_type"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "alt": alt,
        "title": title,
        "width": width,
        "height": height,
        "size": size,
        "mime_type": mimeType,
        "created_at": createdAt.toIso8601String(),
      };
}
