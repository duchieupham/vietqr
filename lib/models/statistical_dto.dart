import 'package:intl/intl.dart';

class ResponseStatisticDTO {
  int totalTrans;
  int totalCashIn;
  int totalCashOut;
  int totalTransC;
  int totalTransD;

  final String date;
  final String timeDate;
  int type;

  ResponseStatisticDTO({
    this.date = '',
    this.timeDate = '',
    this.totalCashIn = 0,
    this.totalCashOut = 0,
    this.totalTrans = 0,
    this.totalTransC = 0,
    this.totalTransD = 0,
    this.type = 0,
  });

  factory ResponseStatisticDTO.fromJson(Map<String, dynamic> json) {
    return ResponseStatisticDTO(
      date: json['date'] ?? '',
      timeDate: json['timeDate'] ?? '',
      totalCashIn: json['totalCashIn'] ?? 0,
      totalCashOut: json['totalCashOut'] ?? 0,
      totalTrans: json['totalTrans'] ?? 0,
      totalTransC: json['totalTransC'] ?? 0,
      totalTransD: json['totalTransD'] ?? 0,
      type: json['type'] ?? 0,
    );
  }

  DateTime formatDateMonth() {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);

    return tempDate;
  }

  String getMonth() {
    return date.substring(5);
  }

  int get getDay => DateTime.parse(date).day;

  String getDayFromMonth() {
    String text = type == 0 ? timeDate : date;

    DateTime dateTime = DateTime.parse(text);

    if (type == 0) return '${dateTime.hour}h';

    return dateTime.day.toString();
  }
}
