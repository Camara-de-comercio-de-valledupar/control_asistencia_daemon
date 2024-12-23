import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final bool isActive;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.isActive,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    bool? isActive,
  }) =>
      User(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        isActive: isActive ?? this.isActive,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        email: json["email"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "is_active": isActive,
      };

  String get fullName => "$firstName $lastName";

  @override
  List<Object?> get props =>
      [id, firstName, lastName, username, email, isActive];

  factory User.empty() => const User(
        id: 0,
        firstName: "",
        lastName: "",
        username: "",
        email: "",
        isActive: false,
      );
}
