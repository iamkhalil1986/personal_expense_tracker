import 'dart:io';

import 'package:intl/intl.dart';

final formatter = NumberFormat.compactSimpleCurrency(
    locale: Platform.localeName, decimalDigits: 2);

//This extension if used for formatting double values into currency format
extension CurrencyParsing on double {
  String parseCurrency() {
    return formatter.format(this);
  }
}

String getCurrencySymbol() {
  return formatter.currencySymbol;
}
