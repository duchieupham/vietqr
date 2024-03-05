// To parse this JSON data, do
//
//     final merchantDto = merchantDtoFromJson(jsonString);

import 'dart:convert';

MerchantDTO merchantDtoFromJson(String str) =>
    MerchantDTO.fromJson(json.decode(str));

String merchantDtoToJson(MerchantDTO data) => json.encode(data.toJson());

class MerchantDTO {
  final String? id;
  final String? merchantId;
  final String? merchantName;
  final String? bankId;
  final String? userId;
  final String? customerId;
  final String? bankAccount;
  final String? userBankName;
  final String? nationalId;
  final String? phoneAuthenticated;
  final String? merchantType;
  final String? vaNumber;

  String get accountBank => '${userBankName ?? ''} - ${bankAccount ?? ''}';

  MerchantDTO({
    this.id,
    this.merchantId,
    this.merchantName,
    this.bankId,
    this.userId,
    this.customerId,
    this.bankAccount,
    this.userBankName,
    this.nationalId,
    this.phoneAuthenticated,
    this.merchantType,
    this.vaNumber,
  });

  factory MerchantDTO.fromJson(Map<String, dynamic> json) => MerchantDTO(
        id: json["id"],
        merchantId: json["merchantId"],
        merchantName: json["merchantName"],
        bankId: json["bankId"],
        userId: json["userId"],
        customerId: json["customerId"],
        bankAccount: json["bankAccount"],
        userBankName: json["userBankName"],
        nationalId: json["nationalId"],
        phoneAuthenticated: json["phoneAuthenticated"],
        merchantType: json["merchantType"],
        vaNumber: json["vaNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "merchantId": merchantId,
        "merchantName": merchantName,
        "bankId": bankId,
        "userId": userId,
        "customerId": customerId,
        "bankAccount": bankAccount,
        "userBankName": userBankName,
        "nationalId": nationalId,
        "phoneAuthenticated": phoneAuthenticated,
        "merchantType": merchantType,
        "vaNumber": vaNumber,
      };
}
