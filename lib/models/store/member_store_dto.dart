// To parse this JSON data, do
//
//     final memberStore = memberStoreFromJson(jsonString);

import 'dart:convert';

import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

List<MemberStoreDTO> memberStoreFromJson(String str) =>
    List<MemberStoreDTO>.from(
        json.decode(str).map((x) => MemberStoreDTO.fromJson(x)));

String memberStoreToJson(List<MemberStoreDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MemberStoreDTO {
  final String id;
  final String phoneNo;
  final String fullName;
  final String imgId;
  final String birthDate;
  final String email;
  final String nationalId;
  final int gender;
  final String role;

  bool get isOwner => role == 'Admin';

  bool get isAdmin => id == SharePrefUtils.getProfile().userId;

  MemberStoreDTO({
    this.id = '',
    this.phoneNo = '',
    this.fullName = '',
    this.imgId = '',
    this.birthDate = '',
    this.email = '',
    this.nationalId = '',
    this.gender = -1,
    this.role = '',
  });

  factory MemberStoreDTO.fromJson(Map<String, dynamic> json) => MemberStoreDTO(
        id: json["id"] ?? '',
        phoneNo: json["phoneNo"] ?? '',
        fullName: json["fullName"] ?? '',
        imgId: json["imgId"] ?? '',
        birthDate: json["birthDate"] ?? '',
        email: json["email"] ?? '',
        nationalId: json["nationalId"] ?? '',
        gender: json["gender"] ?? -1,
        role: json["role"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNo": phoneNo,
        "fullName": fullName,
        "imgId": imgId,
        "birthDate": birthDate,
        "email": email,
        "nationalId": nationalId,
        "gender": gender,
        "role": role,
      };
}
