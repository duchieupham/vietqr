// To parse this JSON data, do
//
//     final storedto = storedtoFromJson(jsonString);

import 'dart:convert';

import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

List<DetailStoreDTO> storeDTOFromJson(String str) => List<DetailStoreDTO>.from(
    json.decode(str).map((x) => DetailStoreDTO.fromJson(x)));

class DetailStoreDTO {
  final String terminalId;
  final String terminalCode;
  final String terminalName;
  final String terminalAddress;
  final String userId;
  final String userBankName;
  final String bankShortName;
  final String bankAccount;
  final String imgId;
  final int totalSubTerminal;
  final String qrCode;
  final int ratePrevDate;
  final int totalTrans;
  final int totalAmount;
  final List<SubTerminal> subTerminals;

  bool get admin => userId == SharePrefUtils.getProfile().userId;

  bool get isHideVietQR =>
      qrCode.isEmpty || bankAccount.isEmpty || bankShortName.isEmpty;

  DetailStoreDTO({
    this.terminalId = '',
    this.terminalCode = '',
    this.terminalName = '',
    this.terminalAddress = '',
    this.userId = '',
    this.userBankName = '',
    this.bankShortName = '',
    this.bankAccount = '',
    this.imgId = '',
    this.totalSubTerminal = 0,
    this.qrCode = '',
    this.ratePrevDate = 0,
    this.totalTrans = 0,
    this.totalAmount = 0,
    this.subTerminals = const [],
  });

  factory DetailStoreDTO.fromJson(Map<String, dynamic> json) => DetailStoreDTO(
        terminalId: json["terminalId"] ?? '',
        terminalCode: json["terminalCode"] ?? ' ',
        terminalName: json["terminalName"] ?? '',
        terminalAddress: json["terminalAddress"] ?? '',
        userId: json["userId"] ?? '',
        userBankName: json["userBankName"] ?? '',
        bankShortName: json["bankShortName"] ?? '',
        bankAccount: json["bankAccount"] ?? '',
        totalSubTerminal: json["totalSubTerminal"] ?? 0,
        qrCode: json["qrCode"] ?? '',
        totalTrans: json["totalTrans"] ?? 0,
        totalAmount: json["totalAmount"] ?? 0,
        ratePrevDate: json["ratePrevDate"] ?? 0,
        imgId: json["imgId"] ?? '',
        subTerminals: json["subTerminals"] == null
            ? []
            : List<SubTerminal>.from(
                json["subTerminals"]!.map((x) => SubTerminal.fromJson(x))),
      );
}

class SubTerminal {
  final String subTerminalId;
  final String subTerminalCode;
  final String subRawTerminalCode;
  final String qrCode;
  final String traceTransfer;
  final String bankId;
  final String subTerminalName;
  final String subTerminalAddress;
  final int ratePrevDate;
  final int totalTrans;
  final int totalAmount;

  SubTerminal({
    this.subTerminalId = '',
    this.subTerminalCode = '',
    this.subRawTerminalCode = '',
    this.qrCode = '',
    this.traceTransfer = '',
    this.bankId = '',
    this.subTerminalName = '',
    this.subTerminalAddress = '',
    this.ratePrevDate = 0,
    this.totalTrans = 0,
    this.totalAmount = 0,
  });

  factory SubTerminal.fromJson(Map<String, dynamic> json) => SubTerminal(
        subTerminalId: json["subTerminalId"] ?? '',
        subTerminalCode: json["subTerminalCode"] ?? '',
        subRawTerminalCode: json["subRawTerminalCode"] ?? '',
        qrCode: json["qrCode"] ?? '',
        traceTransfer: json["traceTransfer"] ?? '',
        bankId: json["bankId"] ?? '',
        subTerminalName: json["subTerminalName"] ?? '',
        subTerminalAddress: json["subTerminalAddress"] ?? '',
        ratePrevDate: json["ratePrevDate"] ?? 0,
        totalTrans: json["totalTrans"] ?? 0,
        totalAmount: json["totalAmount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "subTerminalId": subTerminalId,
        "subTerminalCode": subTerminalCode,
        "subRawTerminalCode": subRawTerminalCode,
        "qrCode": qrCode,
        "traceTransfer": traceTransfer,
        "bankId": bankId,
        "subTerminalName": subTerminalName,
        "subTerminalAddress": subTerminalAddress,
        "ratePrevDate": ratePrevDate,
        "totalTrans": totalTrans,
        "totalAmount": totalAmount,
      };
}
