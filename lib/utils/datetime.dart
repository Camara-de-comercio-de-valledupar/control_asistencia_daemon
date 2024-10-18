import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzi;

String formatDateToHuman(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
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
