import 'dart:io';

import 'package:hive/hive.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

part 'bank_type_dto.g.dart';

@HiveType(typeId: 2)
class BankTypeDTO extends HiveObject {
  @HiveField(1)
  String id;
  @HiveField(2)
  String bankCode;
  @HiveField(3)
  String bankName;
  @HiveField(4)
  String? bankShortName;
  @HiveField(5)
  String imageId;
  @HiveField(6)
  int status;
  @HiveField(7)
  String caiValue;
  @HiveField(8)
  String fileImage;

  File? file;
  String bankId;
  String bankAccount;
  String userBankName;

  LinkBankType get linkType => status.linkType;

  BankTypeDTO({
    this.id = '',
    this.bankCode = '',
    this.bankName = '',
    this.bankShortName = '',
    this.imageId = '',
    this.status = 0,
    this.caiValue = '',
    this.fileImage = '', // dùng lưu local
    this.bankId = '', //dùng cho màn create qr
    this.bankAccount = '', //dùng cho màn create qr
    this.userBankName = '', //dùng cho màn create qr
  });

  BankTypeDTO get copy {
    final objectInstance = BankTypeDTO()
      ..id = id
      ..bankCode = bankCode
      ..bankName = bankName
      ..bankShortName = bankShortName
      ..imageId = imageId
      ..status = status
      ..caiValue = caiValue
      ..bankId = bankId
      ..bankAccount = bankAccount
      ..userBankName = userBankName
      ..fileImage = fileImage;
    return objectInstance;
  }

  get name => '${(bankShortName ?? '')} - $bankName';

  factory BankTypeDTO.fromJson(Map<String, dynamic> json) {
    return BankTypeDTO(
      id: json['id'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      imageId: json['imageId'] ?? '',
      status: json['status'] ?? 0,
      caiValue: json['caiValue'] ?? '',
      bankId: json['bankId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      fileImage: json['fileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['imageId'] = imageId;
    data['status'] = status;
    data['caiValue'] = caiValue;
    return data;
  }

  @override
  int get hashCode => id.hashCode;
}
