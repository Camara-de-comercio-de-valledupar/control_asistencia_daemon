import 'package:intl/intl.dart';

String currencyFormat(int value) {
  return NumberFormat.simpleCurrency(
    decimalDigits: 0,
  ).format(value);
}

int currencyParse(String value) {
  return NumberFormat.simpleCurrency().parse(value).toInt();
}
