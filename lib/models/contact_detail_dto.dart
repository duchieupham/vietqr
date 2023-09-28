import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'contact_detail_dto.g.dart';

@HiveType(typeId: 1)
class ContactDetailDTO {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String? additionalData;
  @HiveField(3)
  final String? nickName;
  @HiveField(4)
  final String? email;
  @HiveField(5)
  final int? type;
  @HiveField(6)
  final int? status;
  @HiveField(7)
  final String? value;
  @HiveField(8)
  final String? bankShortName;
  @HiveField(9)
  final String? bankName;
  @HiveField(10)
  final String? imgId;
  @HiveField(11)
  final String? bankAccount;
  @HiveField(12)
  final int colorType;
  @HiveField(13)
  final int relation;

  ContactDetailDTO({
    this.id = '',
    this.userId = '',
    this.additionalData = '',
    this.nickName = '',
    this.email = '',
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
