import 'package:flutter/material.dart';

class Assistance {
  final int id;
  final int userId;
  final DateTime createdAt;

  Assistance({
    required this.id,
    required this.userId,
    required this.createdAt,
  });

  factory Assistance.fromJson(Map<String, dynamic> json) => Assistance(
        id: json["id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"])
          ..subtract(const Duration(hours: 5)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
      };
}

class AssistanceReport {
  final String userEmail;
  final String userName;
  final DateTime date;
  final DateTime? timeOfEntryMorning;
  final DateTime? timeOfExitMorning;
  final TimeOfDay? timeInOfficeMorning;
  final DateTime? timeOfEntryAfternoon;
  final DateTime? timeOfExitAfternoon;
  final TimeOfDay? timeInOfficeAfternoon;

  AssistanceReport({
    required this.userEmail,
    required this.userName,
    required this.date,
    required this.timeOfEntryMorning,
    required this.timeOfExitMorning,
    required this.timeInOfficeMorning,
    required this.timeOfEntryAfternoon,
    required this.timeOfExitAfternoon,
    required this.timeInOfficeAfternoon,
  });

  AssistanceReport copyWith({
    String? userEmail,
    String? userName,
    DateTime? date,
    DateTime? timeOfEntryMorning,
    DateTime? timeOfExitMorning,
    TimeOfDay? timeInOfficeMorning,
    DateTime? timeOfEntryAfternoon,
    DateTime? timeOfExitAfternoon,
    TimeOfDay? timeInOfficeAfternoon,
  }) =>
      AssistanceReport(
        userEmail: userEmail ?? this.userEmail,
        userName: userName ?? this.userName,
        date: date ?? this.date,
        timeOfEntryMorning: timeOfEntryMorning ?? this.timeOfEntryMorning,
        timeOfExitMorning: timeOfExitMorning ?? this.timeOfExitMorning,
        timeInOfficeMorning: timeInOfficeMorning ?? this.timeInOfficeMorning,
        timeOfEntryAfternoon: timeOfEntryAfternoon ?? this.timeOfEntryAfternoon,
        timeOfExitAfternoon: timeOfExitAfternoon ?? this.timeOfExitAfternoon,
        timeInOfficeAfternoon:
            timeInOfficeAfternoon ?? this.timeInOfficeAfternoon,
      );

  factory AssistanceReport.fromJson(Map<String, dynamic> json) =>
      AssistanceReport(
        userEmail: json["user_email"],
        userName: json["user_name"],
        date: DateTime.parse(json["date"]),
        timeOfEntryMorning: json["time_of_entry_morning"] == null
            ? null
            : DateTime.parse(json["time_of_entry_morning"]).subtract(
                const Duration(hours: 5),
              ),
        timeOfExitMorning: json["time_of_exit_morning"] == null
            ? null
            : DateTime.parse(json["time_of_exit_morning"]).subtract(
                const Duration(hours: 5),
              ),
        timeOfEntryAfternoon: json["time_of_entry_afternoon"] == null
            ? null
            : DateTime.parse(json["time_of_entry_afternoon"]).subtract(
                const Duration(hours: 5),
              ),
        timeOfExitAfternoon: json["time_of_exit_afternoon"] == null
            ? null
            : DateTime.parse(json["time_of_exit_afternoon"]).subtract(
                const Duration(hours: 5),
              ),
        // 20:00:00
        timeInOfficeMorning: json["time_in_office_morning"] == null
            ? null
            : TimeOfDay(
                hour: int.parse(json["time_in_office_morning"].split(":")[0]),
                minute:
                    int.parse(json["time_in_office_morning"].split(":")[1])),
        timeInOfficeAfternoon: json["time_in_office_afternoon"] == null
            ? null
            : TimeOfDay(
                hour: int.parse(json["time_in_office_afternoon"].split(":")[0]),
                minute:
                    int.parse(json["time_in_office_afternoon"].split(":")[1])),
      );
}
