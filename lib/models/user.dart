import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;

  const Member(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.id});

  @override
  List<Object?> get props => [id, firstName, lastName, email];

  factory Member.empty() {
    return const Member(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      email: 'johndoe@unknown.com',
    );
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }
}
