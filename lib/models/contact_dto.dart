import 'package:flutter/material.dart';

class ContactDTO {
  String id;
  String nickname;
  int status;
  int type;
  String imgId;
  String description;
  String phoneNo;
  String carrierTypeId;
  int relation;
  Color? bankColor;
  bool isGetDetail;

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
    this.isGetDetail = false,
  });

  setColor(value) {
    bankColor = value;
  }

  setIsGet(value) {
    isGetDetail = value;
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
        isGetDetail: false,
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

class VCardModel {
  final String? fullname;
  final String? phoneNo;
  final String? email;
  final String? companyName;
  final String? website;
  final String? address;
  final String? userId;
  final String? additionalData;

  VCardModel({
    this.fullname,
    this.phoneNo,
    this.email,
    this.companyName,
    this.website,
    this.address,
    this.userId,
    this.additionalData,
  });

  factory VCardModel.fromJson(Map<String, dynamic> json) => VCardModel(
        fullname: json["fullname"],
        phoneNo: json["phoneNo"],
        email: json["email"],
        companyName: json["companyName"],
        website: json["website"],
        address: json["address"],
        userId: json["userId"],
        additionalData: json["additionalData"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phoneNo": phoneNo,
        "email": email,
        "companyName": companyName,
        "website": website,
        "address": address,
        "userId": userId,
        "additionalData": additionalData,
      };
}
