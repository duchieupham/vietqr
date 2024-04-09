import 'package:intl/intl.dart';

String timestampToDate(int timestamp) {
  // Create a DateTime object from the timestamp
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Format the date in the desired format
  String formattedDate = DateFormat('dd/MM/yyyy').format(date);

  return formattedDate;
}
