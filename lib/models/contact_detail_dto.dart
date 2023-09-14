import 'package:flutter/material.dart';

class ContactDetailDTO {
  final String? id;
  final String? additionalData;
  final String? nickName;
  final int? type;
  final int? status;
  final String? value;
  final String? bankShortName;
  final String? bankName;
  final String? imgId;
  final String? bankAccount;
  final int colorType;
  final int relation;

  ContactDetailDTO({
    this.id = '',
    this.additionalData = '',
    this.nickName = '',
    this.type = 0,
    this.status = 0,
    this.value = '',
    this.bankShortName = '',
    this.bankName = '',
    this.imgId = '',
    this.bankAccount = '',
    this.colorType = 0,
    this.relation = 0,
  });

  factory ContactDetailDTO.fromJson(Map<String, dynamic> json) =>
      ContactDetailDTO(
        additionalData: json["additionalData"],
        nickName: json["nickname"],
        type: json["type"],
        value: json["value"],
        id: json["id"],
        status: json["status"],
        bankShortName: json["bankShortName"],
        imgId: json["imgId"],
        bankAccount: json["bankAccount"],
        bankName: json["bankName"],
        colorType: json["colorType"],
        relation: json["relation"],
      );

  Map<String, dynamic> toJson() => {
        "additionalData": additionalData,
        "nickName": nickName,
        "type": type,
        "value": value,
        "bankName": bankName,
        "bankAccount": bankAccount,
        "imgId": imgId,
        "bankShortName": bankShortName,
        "status": status,
        "id": id,
        "colorType": colorType,
        "relation": relation,
      };

  Gradient getBgGradient() {
    switch (colorType) {
      case 0:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 1:
        return LinearGradient(
          colors: [
            const Color(0xFF52FBFF),
            const Color(0xFF06711B),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 2:
        return LinearGradient(
          colors: [
            const Color(0xFFEECDFF),
            const Color(0xFF49558A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 3:
        return LinearGradient(
          colors: [
            const Color(0xFFFBAE1F),
            const Color(0xFFFC6A01),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 4:
        return LinearGradient(
          colors: [
            const Color(0xFFFF6DC6),
            const Color(0xFFF8837A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
