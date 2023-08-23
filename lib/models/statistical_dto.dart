import 'package:intl/intl.dart';

class ResponseStatisticDTO {
  final int totalTrans;
  final int totalTransC;
  final int totalTransD;
  final int totalCashIn;
  final int totalCashOut;

  final String date;
  final String month;
  const ResponseStatisticDTO(
      {this.date = '',
      this.month = '',
      this.totalCashIn = 0,
      this.totalCashOut = 0,
      this.totalTrans = 0,
      this.totalTransC = 0,
      this.totalTransD = 0});

  factory ResponseStatisticDTO.fromJson(Map<String, dynamic> json) {
    return ResponseStatisticDTO(
      date: json['date'] ?? '',
      month: json['month'] ?? '',
      totalCashIn: json['totalCashIn'] ?? 0,
      totalCashOut: json['totalCashOut'] ?? 0,
      totalTrans: json['totalTrans'] ?? 0,
      totalTransC: json['totalTransC'] ?? 0,
      totalTransD: json['totalTransD'] ?? 0,
    );
  }

  DateTime formatDateMonth() {
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(month);

    return tempDate;
  }

  String getMonth() {
    return month.substring(5);
  }
}
