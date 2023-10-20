import 'package:flutter/material.dart';

class QRGeneratedDTO {
  String? bankId;
  final String bankCode;
  final String bankName;
  final String bankAccount;
  final String userBankName;
  final String amount;
  final String content;
  final String qrCode;
  final String imgId;
  final String? transactionId;
  final int? existing;
  final String? bankTypeId;
  final bool isNaviAddBank;
  final String email;
  final int? type;
  final String phone;

  QRGeneratedDTO({
    this.bankId,
    required this.bankCode,
    required this.bankName,
    required this.bankAccount,
    required this.userBankName,
    required this.amount,
    required this.content,
    required this.qrCode,
    required this.imgId,
    this.transactionId,
    this.existing,
    this.bankTypeId,
    this.email = '',
    this.type,
    this.phone = '',
    this.isNaviAddBank = false,
  });

  setBankId(value) {
    bankId = value;
  }

  factory QRGeneratedDTO.fromJson(Map<String, dynamic> json) {
    return QRGeneratedDTO(
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      amount: json['amount'],
      content: json['content'],
      qrCode: json['qrCode'],
      imgId: json['imgId'],
      transactionId: json['transactionId'],
      existing: json['existing'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['amount'] = amount;
    data['content'] = content;
    data['qrCode'] = qrCode;
    data['imgId'] = imgId;
    data['transactionId'] = transactionId;
    data['existing'] = existing;
    return data;
  }
}
