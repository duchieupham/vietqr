// To parse this JSON data, do
//
//     final storedto = storedtoFromJson(jsonString);

import 'dart:convert';

List<StoreDTO> storeDTOFromJson(String str) =>
    List<StoreDTO>.from(json.decode(str).map((x) => StoreDTO.fromJson(x)));

String storeDTOToJson(List<StoreDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreDTO {
  final String? terminalId;
  final String? terminalCode;
  final String? terminalName;
  final String? terminalAddress;
  final int? totalTrans;
  final int? totalAmount;
  final int? ratePreviousDate;

  StoreDTO({
    this.terminalId,
    this.terminalCode,
    this.terminalName,
    this.terminalAddress,
    this.totalTrans,
    this.totalAmount,
    this.ratePreviousDate,
  });

  factory StoreDTO.fromJson(Map<String, dynamic> json) => StoreDTO(
        terminalId: json["terminalId"],
        terminalCode: json["terminalCode"],
        terminalName: json["terminalName"],
        terminalAddress: json["terminalAddress"],
        totalTrans: json["totalTrans"],
        totalAmount: json["totalAmount"],
        ratePreviousDate: json["ratePreviousDate"],
      );

  Map<String, dynamic> toJson() => {
        "terminalId": terminalId,
        "terminalCode": terminalCode,
        "terminalName": terminalName,
        "terminalAddress": terminalAddress,
        "totalTrans": totalTrans,
        "totalAmount": totalAmount,
        "ratePreviousDate": ratePreviousDate,
      };
}
