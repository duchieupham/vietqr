import 'package:flutter/material.dart';

class BankAccountTerminal {
  final String bankId;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankShortName;
  final String bankName;
  final String imgId;
  final String userId;

  BankAccountTerminal({
    this.bankId = '',
    this.bankAccount = '',
    this.userBankName = '',
    this.bankCode = '',
    this.bankName = '',
    this.imgId = '',
    this.bankShortName = '',
    this.userId = '',
  });

  factory BankAccountTerminal.fromJson(Map<String, dynamic> json,
      {Color? color}) {
    return BankAccountTerminal(
      bankId: json['bankId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  String get getBankCodeAndName => '$bankCode - $bankAccount';
}
