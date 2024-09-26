import 'package:intl/intl.dart';

String timestampToDate(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  String formattedDate = DateFormat('dd/MM/yyyy').format(date);

  return formattedDate;
}

int inclusiveDays(int validFeeTo) {
  DateTime now = DateTime.now();
  int millisecondsSinceEpoch = now.millisecondsSinceEpoch;
  DateTime dateTimeFromMilliseconds =
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  DateTime validTo = DateTime.fromMillisecondsSinceEpoch(validFeeTo * 1000);

  // Calculate the difference in days
  int daysDifference = validTo.difference(dateTimeFromMilliseconds).inDays;

  // Since we want to include both dates, add 1 to the result
  return daysDifference + 1;
}
