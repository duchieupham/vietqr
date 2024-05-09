// To parse this JSON data, do
//
//     final settingAccountDto = settingAccountDtoFromJson(jsonString);

import 'dart:convert';

SettingAccountDTO settingAccountDtoFromJson(String str) =>
    SettingAccountDTO.fromJson(json.decode(str));

String settingAccountDtoToJson(SettingAccountDTO data) =>
    json.encode(data.toJson());

// category:
// 1: tính năng xem GD đã được map cửa hàng theo cấp (toàn bộ, trực thuộc)
// 2: tính năng xem GD chưa xác nhận theo cấp (được duyệt các yêu cầu, yêu cầu duyệt map vào cửa hàng)
// 3: tính năng xuất Excel theo cấp (toàn bộ, trực thuộc)

class SettingAccountDTO {
  final String id;
  final String userId;
  final bool guideWeb;
  final bool guideMobile;
  final bool voiceWeb;
  final bool voiceMobile;
  final bool voiceMobileKiot;
  final bool status;
  final String edgeImgId;
  final String footerImgId;
  final int themeType;
  final String themeImgUrl;
  final String logoUrl;
  bool keepScreenOn;
  final int qrShowType;
  final bool notificationMobile;
  final List<MerchantRole> merchantRoles;

  SettingAccountDTO({
    this.id = '',
    this.userId = '',
    this.guideWeb = false,
    this.guideMobile = false,
    this.voiceWeb = false,
    this.voiceMobile = false,
    this.voiceMobileKiot = false,
    this.status = false,
    this.edgeImgId = '',
    this.footerImgId = '',
    this.themeType = 0,
    this.themeImgUrl = '',
    this.logoUrl = '',
    this.keepScreenOn = false,
    this.qrShowType = 0,
    this.notificationMobile = false,
    this.merchantRoles = const [],
  });

  bool get isEvent => themeType == 0;

  factory SettingAccountDTO.fromJson(Map<String, dynamic> json) =>
      SettingAccountDTO(
        id: json["id"] ?? '',
        userId: json["userId"] ?? '',
        guideWeb: json["guideWeb"] ?? false,
        guideMobile: json["guideMobile"] ?? false,
        voiceWeb: json["voiceWeb"] ?? false,
        voiceMobile: json["voiceMobile"] ?? false,
        voiceMobileKiot: json["voiceMobileKiot"] ?? false,
        status: json["status"] ?? false,
        edgeImgId: json["edgeImgId"] ?? '',
        footerImgId: json["footerImgId"] ?? '',
        themeType: json["themeType"] ?? 0,
        themeImgUrl: json["themeImgUrl"] ?? '',
        logoUrl: json["logoUrl"] ?? '',
        keepScreenOn: json["keepScreenOn"] ?? false,
        qrShowType: json["qrShowType"] ?? 0,
        notificationMobile: json["notificationMobile"] ?? false,
        merchantRoles: List<MerchantRole>.from(
            json["merchantRoles"].map((x) => MerchantRole.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "guideWeb": guideWeb,
        "guideMobile": guideMobile,
        "voiceWeb": voiceWeb,
        "voiceMobile": voiceMobile,
        "voiceMobileKiot": voiceMobileKiot,
        "status": status,
        "edgeImgId": edgeImgId,
        "footerImgId": footerImgId,
        "themeType": themeType,
        "themeImgUrl": themeImgUrl,
        "logoUrl": logoUrl,
        "keepScreenOn": keepScreenOn,
        "qrShowType": qrShowType,
        "notificationMobile": notificationMobile,
        "merchantRoles":
            List<dynamic>.from(merchantRoles.map((x) => x.toJson())),
      };
}

class MerchantRole {
  final String merchantId;
  final String bankId;
  final List<Role> roles;
  bool isOwner;

  MerchantRole({
    this.merchantId = '',
    this.bankId = '',
    this.roles = const [],
    this.isOwner = false,
  });

  bool get isAdmin =>
      (roles.indexWhere((element) => element.isAdmin) != -1) || isOwner;

  bool get isRequestTrans =>
      (roles.indexWhere((element) => element.isRequestTrans) != -1) && !isOwner;

  factory MerchantRole.fromJson(Map<String, dynamic> json) => MerchantRole(
        merchantId: json["merchantId"] ?? '',
        bankId: json["bankId"] ?? '',
        roles: json["roles"] != null
            ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
            : [],
        isOwner: false,
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "bankId": bankId,
        "roles": List<dynamic>.from(roles.map((x) => x)),
      };
}

class Role {
  final int category;
  final int role;

  Role({
    this.category = 0,
    this.role = 0,
  });

  // Case 3: User có toàn quyền cập nhật giao dịch.
  // isOwner = true || category = 2 AND role = 2

  bool get isAdmin => category == 2 && role == 2;

  bool get isRequestTrans => category == 2 && role == 4;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        category: json["category"] ?? 0,
        role: json["role"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "role": role,
      };
}
