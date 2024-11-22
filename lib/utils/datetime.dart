import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzi;

String formatDateToHuman(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  return formatter.format(date);
}

String formatDateToHumanDate(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

String formatTimeOfDay(TimeOfDay? time) {
  if (time == null) {
    return 'No registrado';
  }

  return '${time.hour} horas y ${time.minute} minutos';
}

String formatDatetimeToHourMinute(DateTime? date) {
  if (date == null) {
    return 'No registrado';
  }
  final formatter = DateFormat('HH:mm');
  return formatter.format(date);
}

DateTime convertUTCToBogota(DateTime utcDateTime) {
  final bgTimeZone = tz.getLocation('America/Bogota');

  final bgTime = tz.TZDateTime.from(utcDateTime, bgTimeZone);

  return bgTime;
}

void initializeTimezone() {
  tzi.initializeTimeZones();
}

bool isLate(
  DateTime? date, {
  int hour = 0,
}) {
  if (date == null) {
    return false;
  }

  final limitDate = DateTime(date.year, date.month, date.day, hour, 0, 0);

  return date.isAfter(limitDate);
}
