import 'package:intl/intl.dart';

class ResponseStatisticDTO {
  int totalTrans;
  int totalCashIn;
  int totalCashOut;
  int totalTransC;
  int totalTransD;

  final String date;
  int type;

  ResponseStatisticDTO({
    this.date = '',
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
      totalCashIn: json['totalCashIn'] ?? 0,
      totalCashOut: json['totalCashOut'] ?? 0,
      totalTrans: json['totalTrans'] ?? 0,
      totalTransC: json['totalTransC'] ?? 0,
      totalTransD: json['totalTransD'] ?? 0,
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
    DateTime dateTime = DateTime.parse(date);
    return dateTime.day.toString();
  }
}
