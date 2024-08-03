import 'package:flutter/material.dart';

import 'bank_type_dto.dart';

class BankAccountDTO {
  final String id;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankShortName;
  final String bankName;
  final String imgId;
  final int type;
  final String userId;
  bool isAuthenticated;
  bool isOwner;
  int bankTypeStatus;
  final String qrCode;
  final String caiValue;
  final String bankTypeId;
  final String phoneAuthenticated;
  final String nationalId;
  final String ewalletToken;
  final int unlinkedType;
  bool? isValidService;
  int? validFeeFrom;
  int? validFeeTo;
  int? transCount;
  String? keyActive;
  int? timeActiveKey;
  bool? activeKey;
  bool mmsActive;

  //thêm
  Color? bankColor;
  double position;

  setPosition(double value) {
    position = position - value;
  }

  bool get isLinked => (!isAuthenticated && bankTypeStatus == 1 && isOwner);

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
    this.position = 0.0,
    this.qrCode = '',
    this.caiValue = '',
    this.bankTypeId = '',
    this.phoneAuthenticated = '',
    this.nationalId = '',
    this.ewalletToken = '',
    this.unlinkedType = -1,
    this.bankTypeStatus = -1,
    this.isValidService,
    this.validFeeFrom,
    this.validFeeTo,
    this.transCount,
    this.activeKey = false,
    this.mmsActive = false,
    this.keyActive = '',
    this.timeActiveKey = 0,
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
      qrCode: json['qrCode'] ?? '',
      bankTypeStatus: json['bankTypeStatus'] ?? -1,
      caiValue: json['caiValue'] ?? '',
      bankTypeId: json['bankTypeId'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      nationalId: json['nationalId'] ?? '',
      ewalletToken: json['ewalletToken'] ?? '',
      unlinkedType: json['unlinkedType'] ?? -1,
      isValidService: json['isValidService'],
      validFeeFrom: json['validFeeFrom'],
      validFeeTo: json['validFeeTo'],
      transCount: json['transCount'],
      keyActive: json['keyActive'] ?? '',
      activeKey: json['activeKey'] ?? false,
      mmsActive: json['mmsActive'] ?? false,
      timeActiveKey: json['timeActiveKey'] ?? 1,
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
    data['unlinkedType'] = unlinkedType;
    data['transCount'] = transCount;
    return data;
  }

  String get getBankCodeAndName => '$bankCode - $bankAccount';

  BankTypeDTO get changeToBankTypeDTO => BankTypeDTO(
        id: bankTypeId,
        bankCode: bankCode,
        bankName: bankName,
        imageId: imgId,
        bankShortName: bankCode,
        status: bankTypeStatus,
        caiValue: caiValue,
        bankId: id,
        bankAccount: bankAccount,
        userBankName: userBankName,
      );
}
