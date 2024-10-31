import 'package:intl/intl.dart';

double convertStringtoDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

String formatAmount(double amount) {
  final format =
      NumberFormat.currency(locale: "HI", symbol: "₹", decimalDigits: 2);
  return format.format(amount);
}
