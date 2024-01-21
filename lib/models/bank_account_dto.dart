import 'package:flutter/material.dart';

class BankAccountDTO {
  final String id;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final int type;
  final bool isAuthenticated;
  final bool isOwner;
  final String bankShortName;
  final String userId;

  Color? bankColor;
  bool isFirst;

  // final String branchCode;
  // final String businessCode;

  BankAccountDTO({
    this.id = '',
    this.bankAccount = '',
    this.userBankName = '',
    this.bankCode = '',
    this.bankName = '',
    this.imgId = '',
    this.type = 0,
    this.isAuthenticated = false,
    this.bankShortName = '',
    this.isOwner = false,
    this.userId = '',
    this.bankColor,
    this.isFirst = false,
    // required this.branchCode,
    // required this.businessCode,
  });

  setColor(value) {
    bankColor = value;
  }

  factory BankAccountDTO.fromJson(Map<String, dynamic> json, {Color? color}) {
    return BankAccountDTO(
      id: json['id'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      type: json['type'] ?? 0,
      isAuthenticated: json['authenticated'] ?? false,
      isOwner: json['isOwner'] ?? false,
      userId: json['userId'] ?? '',
      isFirst: false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['imgId'] = imgId;
    data['type'] = type;
    data['isOwner'] = isOwner;
    data['bankShortName'] = bankShortName;
    data['authenticated'] = isAuthenticated;
    data['userId'] = userId;
    return data;
  }
}
