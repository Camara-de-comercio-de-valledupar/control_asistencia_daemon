import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:control_asistencia_daemon/lib.dart';

class Member extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final List<Role> roles;
  final List<Permission> permissions;

  const Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.roles,
    required this.permissions,
  });

  Member copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    List<Role>? roles,
    List<Permission>? permissions,
  }) =>
      Member(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        roles: roles ?? this.roles,
        permissions: permissions ?? this.permissions,
      );

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        roles: List<Role>.from(json["roles"].map((x) => roleFromString(x))),
        permissions: List<Permission>.from(
            json["permissions"].map((x) => permissionFromString(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "roles": List<dynamic>.from(roles.map((x) => roleToString(x))),
        "permissions":
            List<dynamic>.from(permissions.map((x) => permissionToString(x))),
      };

  @override
  List<Object?> get props =>
      [id, firstName, lastName, username, email, roles, permissions];
}

MemberAppCCvalledupar memberAppCCvalleduparFromJson(String json) {
  return MemberAppCCvalledupar.fromJson(jsonDecode(json));
}

String memberAppCCvalleduparToJson(MemberAppCCvalledupar data) {
  return json.encode(data.toJson());
}

class MemberAppCCvalledupar extends Equatable {
  final int id;
  final String dni;
  final String firstName;
  final String lastName;
  final String? photo;
  final String jonRole;
  final String email;
  final String role;
  final String area;

  const MemberAppCCvalledupar({
    required this.id,
    required this.dni,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photo,
    required this.jonRole,
    required this.role,
    required this.area,
  });

  MemberAppCCvalledupar copyWith({
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
      MemberAppCCvalledupar(
        id: id ?? this.id,
        dni: dni ?? this.dni,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        jonRole: jonRole ?? this.jonRole,
        role: role ?? this.role,
        area: area ?? this.area,
      );

  factory MemberAppCCvalledupar.fromJson(Map<String, dynamic> json) =>
      MemberAppCCvalledupar(
        id: json["id"],
        dni: json["noDocumento"],
        firstName: json["nombres"],
        lastName: json["apellidos"],
        email: json["email"],
        photo: json["foto"],
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
        "foto": photo,
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
        photo,
        jonRole,
        role,
        area,
      ];
}
