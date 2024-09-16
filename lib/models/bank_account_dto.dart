import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'bank_type_dto.dart';

// ignore: must_be_immutable
class BankAccountDTO extends Equatable {
  final String id;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankShortName;
  final String bankName;
  final String imgId;
  final int type;
  bool enableVoice;
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
  bool isValidService;
  int validFeeFrom;
  int validFeeTo;
  int transCount;
  String keyActive;
  int timeActiveKey;
  bool activeKey;
  bool mmsActive;
  int pushNotification;

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
    this.isValidService = false,
    this.validFeeFrom = 0,
    this.validFeeTo = 0,
    this.transCount = 0,
    this.activeKey = false,
    this.mmsActive = false,
    this.keyActive = '',
    this.timeActiveKey = 0,
    this.enableVoice = true,
    this.pushNotification = 0,
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
      validFeeTo: json['validFeeTo'] ?? 0,
      transCount: json['transCount'] ?? 0,
      keyActive: json['keyActive'] ?? '',
      activeKey: json['activeKey'] ?? false,
      mmsActive: json['mmsActive'] ?? false,
      timeActiveKey: json['timeActiveKey'] ?? 1,
      enableVoice: json['enableVoice'] ?? true,
      pushNotification: json['pushNotification'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['bankCode'] = bankCode;
    data['bankShortName'] = bankShortName;
    data['bankName'] = bankName;
    data['imgId'] = imgId;
    data['type'] = type;
    data['enableVoice'] = enableVoice;
    data['userId'] = userId;
    data['isAuthenticated'] = isAuthenticated;
    data['isOwner'] = isOwner;
    data['bankTypeStatus'] = bankTypeStatus;
    data['qrCode'] = qrCode;
    data['caiValue'] = caiValue;
    data['bankTypeId'] = bankTypeId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    data['nationalId'] = nationalId;
    data['ewalletToken'] = ewalletToken;
    data['unlinkedType'] = unlinkedType;
    data['isValidService'] = isValidService;
    data['validFeeFrom'] = validFeeFrom;
    data['validFeeTo'] = validFeeTo;
    data['transCount'] = transCount;
    data['keyActive'] = keyActive;
    data['timeActiveKey'] = timeActiveKey;
    data['activeKey'] = activeKey;
    data['mmsActive'] = mmsActive;
    data['pushNotification'] = pushNotification;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        bankAccount,
        userBankName,
        bankCode,
        bankShortName,
        bankName,
        imgId,
        type,
        enableVoice,
        userId,
        isAuthenticated,
        isOwner,
        bankTypeStatus,
        qrCode,
        caiValue,
        bankTypeId,
        phoneAuthenticated,
        nationalId,
        ewalletToken,
        unlinkedType,
        isValidService,
        validFeeFrom,
        validFeeTo,
        transCount,
        keyActive,
        timeActiveKey,
        activeKey,
        mmsActive,
        pushNotification,
      ];

  BankAccountDTO copyWith(
      {String? id,
      String? bankAccount,
      String? userBankName,
      String? bankCode,
      String? bankShortName,
      String? bankName,
      String? imgId,
      int? type,
      bool? enableVoice,
      String? userId,
      bool? isAuthenticated,
      bool? isOwner,
      int? bankTypeStatus,
      String? qrCode,
      String? caiValue,
      String? bankTypeId,
      String? phoneAuthenticated,
      String? nationalId,
      String? ewalletToken,
      int? unlinkedType,
      bool? isValidService,
      int? validFeeFrom,
      int? validFeeTo,
      int? transCount,
      String? keyActive,
      int? timeActiveKey,
      bool? activeKey,
      bool? mmsActive,
      int? pushNotification}) {
    return BankAccountDTO(
        id: id ?? this.id,
        bankAccount: bankAccount ?? this.bankAccount,
        userBankName: userBankName ?? this.userBankName,
        bankCode: bankCode ?? this.bankCode,
        bankShortName: bankShortName ?? this.bankShortName,
        bankName: bankName ?? this.bankName,
        imgId: imgId ?? this.imgId,
        type: type ?? this.type,
        enableVoice: enableVoice ?? this.enableVoice,
        userId: userId ?? this.userId,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        isOwner: isOwner ?? this.isOwner,
        bankTypeStatus: bankTypeStatus ?? this.bankTypeStatus,
        qrCode: qrCode ?? this.qrCode,
        caiValue: caiValue ?? this.caiValue,
        bankTypeId: bankTypeId ?? this.bankTypeId,
        phoneAuthenticated: phoneAuthenticated ?? this.phoneAuthenticated,
        nationalId: nationalId ?? this.nationalId,
        ewalletToken: ewalletToken ?? this.ewalletToken,
        unlinkedType: unlinkedType ?? this.unlinkedType,
        isValidService: isValidService ?? this.isValidService,
        validFeeFrom: validFeeFrom ?? this.validFeeFrom,
        validFeeTo: validFeeTo ?? this.validFeeTo,
        transCount: transCount ?? this.transCount,
        keyActive: keyActive ?? this.keyActive,
        timeActiveKey: timeActiveKey ?? this.timeActiveKey,
        activeKey: activeKey ?? this.activeKey,
        mmsActive: mmsActive ?? this.mmsActive,
        pushNotification: pushNotification ?? this.pushNotification);
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
