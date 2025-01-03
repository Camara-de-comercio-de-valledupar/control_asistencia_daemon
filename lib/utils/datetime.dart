import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzi;
import 'package:timezone/timezone.dart' as tz;

String formatDateToHuman(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  return formatter.format(date);
}

// Formatea la fecha a un formato de legible en español
// Ejemplo: 10 de octubre de 2022 -> 10/10/2022
String formatDateToSpanishDate(DateTime date) {
  final formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
  return formatter.format(date).capitalize!;
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

Future<void> initializeTimezone() async {
  await initializeDateFormatting("es", null);
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

bool isWithinDateRange(DateTime date, DateTime start, DateTime end) {
  return date.isAfter(start) && date.isBefore(end) ||
      date.isAtSameMomentAs(start) ||
      date.isAtSameMomentAs(end);
}
