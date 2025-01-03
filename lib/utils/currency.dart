import 'package:intl/intl.dart';

String currencyFormat(int value) {
  return NumberFormat.simpleCurrency(
    decimalDigits: 0,
  ).format(value);
}

int currencyParse(String value) {
  return NumberFormat.simpleCurrency().parse(value).toInt();
}

String dniFormat(String value) {
  // Ej: 12345678 -> 12.345.678
  // Ej: 1234567 -> 1.234.567
  // Ej: 123456 -> 123.456

  final text = value.replaceAll(RegExp(r'[.]'), '');

  // Hacer split de cada 3 caracteres de reverso
  final List<String> split = text.split('').reversed.toList();
  final List<String> result = [];
  for (var i = 0; i < split.length; i++) {
    if (i % 3 == 0 && i != 0) {
      result.add('.');
    }
    result.add(split[i]);
  }

  return result.reversed.join('');
}
