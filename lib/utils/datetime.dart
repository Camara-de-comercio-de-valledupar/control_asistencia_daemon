import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzi;
import 'package:intl/date_symbol_data_local.dart';

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

Future<void> initializeTimezone() async {
  await FlutterLocalization.instance.ensureInitialized();
  FlutterLocalization.instance.init(
    mapLocales: [
      const MapLocale("es", AppLocale.ES),
      const MapLocale("en", AppLocale.EN),
      const MapLocale("KM", AppLocale.KM),
    ],
    initLanguageCode: "es",
  );
  await initializeDateFormatting("es_CO", null);
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
