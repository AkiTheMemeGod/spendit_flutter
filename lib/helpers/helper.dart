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

int calccurrentmonth(
    int startyear, int startmonth, int currentyear, int currentmonth) {
  int monthcount =
      (startyear - currentyear) * 12 + currentmonth - startmonth + 1;
  return monthcount;
}
