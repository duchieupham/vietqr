// To parse this JSON data, do
//
//     final totalStore = totalStoreFromJson(jsonString);

import 'dart:convert';

TotalStoreDTO totalStoreFromJson(String str) =>
    TotalStoreDTO.fromJson(json.decode(str));

String totalStoreToJson(TotalStoreDTO data) => json.encode(data.toJson());

class TotalStoreDTO {
  final String? merchantId;
  final String? merchantName;
  final String? vsoCode;
  final DateTime? date;
  final int? totalTrans;
  final int? totalAmount;
  int? totalTerminal;
  final int? ratePreviousDate;
  final int? ratePreviousMonth;

  TotalStoreDTO({
    this.merchantId,
    this.merchantName,
    this.vsoCode,
    this.date,
    this.totalTrans,
    this.totalAmount,
    this.totalTerminal,
    this.ratePreviousDate,
    this.ratePreviousMonth,
  });

  factory TotalStoreDTO.fromJson(Map<String, dynamic> json) => TotalStoreDTO(
        merchantId: json["merchantId"],
        merchantName: json["merchantName"],
        vsoCode: json["vsoCode"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        totalTrans: json["totalTrans"],
        totalAmount: json["totalAmount"],
        totalTerminal: json["totalTerminal"],
        ratePreviousDate: json["ratePreviousDate"],
        ratePreviousMonth: json["ratePreviousMonth"],
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "merchantName": merchantName,
        "vsoCode": vsoCode,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "totalTrans": totalTrans,
        "totalAmount": totalAmount,
        "totalTerminal": totalTerminal,
        "ratePreviousDate": ratePreviousDate,
        "ratePreviousMonth": ratePreviousMonth,
      };
}
