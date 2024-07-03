import 'dart:convert';
import 'dart:io';

class QrCreateTypeDto {
  String type;
  //0: QrLink
  //1: QrOther
  //2: QrVard
  //3: VietQr

  dynamic json;

  QrCreateTypeDto({
    required this.type,
    this.json,
  });

  factory QrCreateTypeDto.fromJson(Map<String, dynamic> data) {
    final type = data['type'] as String;
    switch (type) {
      case '0':
        return QrCreateTypeDto(
          type: type,
          json: QrLink.fromJson(data['json'] as Map<String, dynamic>),
        );
      case '1':
        return QrCreateTypeDto(
          type: type,
          json: QrOther.fromJson(data['json'] as Map<String, dynamic>),
        );
      case '2':
        return QrCreateTypeDto(
          type: type,
          json: QrVCard.fromJson(data['json'] as Map<String, dynamic>),
        );
      case '3':
        return QrCreateTypeDto(
          type: type,
          json: VietQr.fromJson(data['json'] as Map<String, dynamic>),
        );
      default:
        throw Exception('Unknown type');
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    switch (type) {
      case '0':
        QrLink dto = json as QrLink;
        data = dto.toJson();
        break;
      case '1':
        QrOther dto = json as QrOther;
        data = dto.toJson();
        break;
      case '2':
        QrVCard dto = json as QrVCard;
        data = dto.toJson();
        break;
      case '3':
        VietQr dto = json as VietQr;
        data = dto.toJson();
        break;
      default:
    }
    return {
      'type': type,
      'json': data,
    };
  }
}

class QrLink {
  String userId;
  String qrName;
  String qrDescription;
  String value;
  String pin;
  String isPublic;
  String style;
  String theme;

  QrLink({
    required this.userId,
    required this.qrName,
    required this.qrDescription,
    required this.value,
    required this.pin,
    required this.isPublic,
    required this.style,
    required this.theme,
  });

  factory QrLink.fromJson(Map<String, dynamic> json) {
    return QrLink(
      userId: json['userId'],
      qrName: json['qrName'],
      qrDescription: json['qrDescription'],
      value: json['value'],
      pin: json['pin'],
      isPublic: json['isPublic'],
      style: json['style'],
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'qrName': qrName,
      'qrDescription': qrDescription,
      'value': value,
      'pin': pin,
      'isPublic': isPublic,
      'style': style,
      'theme': theme,
    };
  }
}

class QrOther {
  String userId;
  String qrName;
  String qrDescription;
  String value;
  String pin;
  String isPublic;
  String style;
  String theme;

  QrOther({
    required this.userId,
    required this.qrName,
    required this.qrDescription,
    required this.value,
    required this.pin,
    required this.isPublic,
    required this.style,
    required this.theme,
  });

  factory QrOther.fromJson(Map<String, dynamic> json) {
    return QrOther(
      userId: json['userId'],
      qrName: json['qrName'],
      qrDescription: json['qrDescription'],
      value: json['value'],
      pin: json['pin'],
      isPublic: json['isPublic'],
      style: json['style'],
      theme: json['theme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'qrName': qrName,
      'qrDescription': qrDescription,
      'value': value,
      'pin': pin,
      'isPublic': isPublic,
      'style': style,
      'theme': theme,
    };
  }
}

class QrVCard {
  String qrName;
  String qrDescription;
  String fullname;
  String phoneNo;
  String email;
  String companyName;
  String website;
  String address;
  String userId;
  String additionalData;
  String style;
  String theme;
  String isPublic;

  QrVCard({
    required this.qrName,
    required this.qrDescription,
    required this.fullname,
    required this.phoneNo,
    required this.email,
    required this.companyName,
    required this.website,
    required this.address,
    required this.userId,
    required this.additionalData,
    required this.style,
    required this.theme,
    required this.isPublic,
  });

  factory QrVCard.fromJson(Map<String, dynamic> json) {
    return QrVCard(
      qrName: json['qrName'],
      qrDescription: json['qrDescription'],
      fullname: json['fullname'],
      phoneNo: json['phoneNo'],
      email: json['email'],
      companyName: json['companyName'],
      website: json['website'],
      address: json['address'],
      userId: json['userId'],
      additionalData: json['additionalData'],
      style: json['style'],
      theme: json['theme'],
      isPublic: json['isPublic'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qrName'] = this.qrName;
    data['qrDescription'] = this.qrDescription;
    data['fullname'] = this.fullname;
    data['phoneNo'] = this.phoneNo;
    data['email'] = this.email;
    data['companyName'] = this.companyName;
    data['website'] = this.website;
    data['address'] = this.address;
    data['userId'] = this.userId;
    data['additionalData'] = this.additionalData;
    data['style'] = this.style;
    data['theme'] = this.theme;
    data['isPublic'] = this.isPublic;
    return data;
  }
}

class VietQr {
  String userId;
  String qrName;
  String qrDescription;
  String bankAccount;
  String bankCode;
  String userBankName;
  String amount;
  String content;
  String isPublic;
  String style;
  String theme;

  VietQr({
    required this.userId,
    required this.qrName,
    required this.qrDescription,
    required this.bankAccount,
    required this.bankCode,
    required this.userBankName,
    required this.amount,
    required this.content,
    required this.isPublic,
    required this.style,
    required this.theme,
  });

  // Factory constructor to create an instance from a map (JSON)
  factory VietQr.fromJson(Map<String, dynamic> json) {
    return VietQr(
      userId: json['userId'],
      qrName: json['qrName'],
      qrDescription: json['qrDescription'],
      bankAccount: json['bankAccount'],
      bankCode: json['bankCode'],
      userBankName: json['userBankName'],
      amount: json['amount'],
      content: json['content'],
      isPublic: json['isPublic'],
      style: json['style'],
      theme: json['theme'],
    );
  }

  // Method to convert an instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'qrName': qrName,
      'qrDescription': qrDescription,
      'bankAccount': bankAccount,
      'bankCode': bankCode,
      'userBankName': userBankName,
      'amount': amount,
      'content': content,
      'isPublic': isPublic,
      'style': style,
      'theme': theme,
    };
  }

  // Method to convert an instance to a JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
