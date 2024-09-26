import 'dart:io';

class AddContactDTO {
  final String? additionalData;
  final String? nickName;
  final String? type;
  final String? colorType;
  final String? value;
  final String? userId;
  final String? bankTypeId;
  final String? bankAccount;
  final File? image;
  final int? relation;

  AddContactDTO({
    this.additionalData,
    this.nickName,
    this.type,
    this.value,
    this.userId,
    this.colorType,
    this.bankTypeId,
    this.bankAccount,
    this.image,
    this.relation,
  });

  factory AddContactDTO.fromJson(Map<String, dynamic> json) => AddContactDTO(
        additionalData: json["additionalData"],
        nickName: json["nickName"],
        type: json["type"],
        value: json["value"],
        colorType: json["colorType"],
        userId: json["userId"],
        bankTypeId: json["bankTypeId"],
        bankAccount: json["bankAccount"],
        relation: json["relation"],
      );

  Map<String, dynamic> toJson() => {
        "additionalData": additionalData,
        "nickName": nickName,
        "type": type,
        "value": value,
        "userId": userId,
        "colorType": colorType,
        "bankTypeId": bankTypeId,
        "bankAccount": bankAccount,
        "relation": relation.toString(),
      };
}
