import 'package:control_asistencia_daemon/lib.dart';

class Assistance {
  final String id;
  final String pictureUrl;
  final DateTime createdAt;
  final Member member;

  Assistance({
    required this.id,
    required this.pictureUrl,
    required this.createdAt,
    required this.member,
  });

  factory Assistance.fromJson(Map<String, dynamic> json) {
    return Assistance(
      id: json['id'],
      pictureUrl: json['pictureUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      member: Member.fromJson(json['member']),
    );
  }
}
