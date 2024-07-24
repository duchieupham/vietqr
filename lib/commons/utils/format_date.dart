import 'package:intl/intl.dart';

String timestampToDate(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  String formattedDate = DateFormat('dd/MM/yyyy').format(date);

  return formattedDate;
}
