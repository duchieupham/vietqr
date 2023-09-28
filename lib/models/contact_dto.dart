import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'contact_dto.g.dart';

@HiveType(typeId: 0)
class ContactDTO {
  @HiveField(0)
  String id;
  @HiveField(1)
  String nickname;
  @HiveField(2)
  int status;
  @HiveField(3)
  int type;
  @HiveField(4)
  String imgId;
  @HiveField(5)
  String description;
  @HiveField(6)
  String phoneNo;
  @HiveField(7)
  String carrierTypeId;
  @HiveField(8)
  int relation;
  @HiveField(9)
  Color? bankColor;

  ContactDTO({
    required this.id,
    required this.nickname,
    required this.status,
    required this.type,
    required this.imgId,
    required this.description,
    required this.phoneNo,
    required this.carrierTypeId,
    required this.relation,
    this.bankColor,
  });

  setColor(value) {
    bankColor = value;
  }

  factory ContactDTO.fromJson(Map<String, dynamic> json) => ContactDTO(
        id: json["id"] ?? '',
        nickname: json["nickname"] ?? '',
        status: json["status"] ?? 0,
        type: json["type"] ?? 0,
        imgId: json["imgId"] ?? '',
        description: json["description"] ?? '',
        phoneNo: json["phoneNo"] ?? '',
        carrierTypeId: json["carrierTypeId"] ?? '',
        relation: json["relation"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "status": status,
        "type": type,
        "imgId": imgId,
        "description": description,
        "phoneNo": phoneNo,
        "carrierTypeId": carrierTypeId,
        "relation": relation,
      };
}
