import 'package:equatable/equatable.dart';
import 'package:control_asistencia_daemon/lib.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final List<Role> roles;
  final List<Permission> permissions;
  final bool isActive;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.roles,
    required this.permissions,
    required this.isActive,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    List<Role>? roles,
    List<Permission>? permissions,
    bool? isActive,
  }) =>
      User(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        roles: roles ?? this.roles,
        permissions: permissions ?? this.permissions,
        isActive: isActive ?? this.isActive,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        roles: List<Role>.from(json["roles"].map((x) => roleFromString(x))),
        permissions: List<Permission>.from(
            json["permissions"].map((x) => permissionFromString(x))),
        isActive: json["is_active"],
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
        "is_active": isActive,
      };

  String get fullName => "$firstName $lastName";

  @override
  List<Object?> get props =>
      [id, firstName, lastName, username, email, roles, permissions, isActive];

  factory User.empty() => const User(
        id: 0,
        firstName: "",
        lastName: "",
        username: "",
        email: "",
        roles: [],
        permissions: [],
        isActive: false,
      );
}
