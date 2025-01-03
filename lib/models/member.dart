import 'dart:convert';

import 'package:equatable/equatable.dart';

Member memberFromJson(String json) {
  return Member.fromJson(jsonDecode(json));
}

String memberToJson(Member data) {
  return json.encode(data.toJson());
}

class Member extends Equatable {
  final int id;
  final String dni;
  final String firstName;
  final String lastName;
  final String jonRole;
  final String email;
  final String role;
  final String area;

  const Member({
    required this.id,
    required this.dni,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.jonRole,
    required this.role,
    required this.area,
  });

  Member copyWith({
    int? id,
    String? dni,
    String? firstName,
    String? lastName,
    String? email,
    String? photo,
    String? jonRole,
    String? role,
    String? area,
  }) =>
      Member(
        id: id ?? this.id,
        dni: dni ?? this.dni,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        jonRole: jonRole ?? this.jonRole,
        role: role ?? this.role,
        area: area ?? this.area,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"].toInt(),
        dni: json["noDocumento"],
        firstName: json["nombres"],
        lastName: json["apellidos"],
        email: json["email"],
        jonRole: json["cargo"],
        role: json["role"],
        area: json["area_laboral"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "noDocumento": dni,
        "nombres": firstName,
        "apellidos": lastName,
        "email": email,
        "cargo": jonRole,
        "role": role,
        "area_laboral": area,
      };

  @override
  List<Object?> get props => [
        id,
        dni,
        firstName,
        lastName,
        email,
        jonRole,
        role,
        area,
      ];
}
