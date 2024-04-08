import 'package:intl/intl.dart';

String formatPrice(int? price) {
  return NumberFormat.simpleCurrency(locale: 'vi').format(price);
}

String formatNumber(int? number) {
  NumberFormat formatter = NumberFormat('###,###');
  return formatter.format(number);
}

String formatPriceWithoutUnit(int? price) {
  NumberFormat format = NumberFormat("###0.00");
  format.minimumFractionDigits = 0;
  return format.format(price);
}
