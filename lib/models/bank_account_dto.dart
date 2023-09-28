import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/main.dart';

class BankAccountDTO {
  final String id;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final int type;
  final String branchId;
  final String businessId;
  final String branchName;
  final String businessName;
  final bool isAuthenticated;
  final String? userId;

  Color? bankColor;

  // final String branchCode;
  // final String businessCode;

  BankAccountDTO({
    required this.id,
    required this.bankAccount,
    required this.userBankName,
    required this.bankCode,
    required this.bankName,
    required this.imgId,
    required this.type,
    required this.branchId,
    required this.businessId,
    required this.branchName,
    required this.businessName,
    required this.isAuthenticated,
    this.userId,
    this.bankColor,
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
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      type: json['type'] ?? 0,
      branchId: json['branchId'] ?? '',
      businessId: json['businessId'] ?? '',
      branchName: json['branchName'] ?? '',
      businessName: json['businessName'] ?? '',
      isAuthenticated: json['authenticated'] ?? false,
      userId: json['userId'] ?? '',
      // branchCode: json['branchCode'],
      // businessCode: json['businessCode'],
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
    data['branchId'] = branchId;
    data['businessId'] = businessId;
    data['branchName'] = branchName;
    data['businessName'] = businessName;
    data['authenticated'] = isAuthenticated;
    data['userId'] = userId;
    return data;
  }
}
