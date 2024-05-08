import 'dart:convert';

class InfoGgChatDTO {
  String? id;
  String? webhook;
  String? userId;
  List<BankInfoGgChat>? banks;

  InfoGgChatDTO({this.id, this.webhook, this.userId, this.banks});

  factory InfoGgChatDTO.fromJson(Map<String, dynamic> json) => InfoGgChatDTO(
        id: json['id'],
        webhook: json['webhook'],
        userId: json['userId'],
        banks: List<BankInfoGgChat>.from(
            json['banks'].map((x) => BankInfoGgChat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'webhook': webhook,
        'userId': userId,
        'banks': List<dynamic>.from(banks!.map((x) => x.toJson())),
      };
}

class BankInfoGgChat {
  String? bankCode;
  String? bankAccount;
  String? bankShortName;
  String? bankId;
  String? userBankName;
  String? imgId;
  String? googleChatBankId;

  BankInfoGgChat({
    this.bankCode,
    this.bankAccount,
    this.bankShortName,
    this.bankId,
    this.userBankName,
    this.imgId,
    this.googleChatBankId,
  });

  factory BankInfoGgChat.fromJson(Map<String, dynamic> json) => BankInfoGgChat(
        bankCode: json['bankCode'],
        bankAccount: json['bankAccount'],
        bankShortName: json['bankShortName'],
        bankId: json['bankId'],
        userBankName: json['userBankName'],
        imgId: json['imgId'],
        googleChatBankId: json['googleChatBankId'],
      );

  Map<String, dynamic> toJson() => {
        'bankCode': bankCode,
        'bankAccount': bankAccount,
        'bankShortName': bankShortName,
        'bankId': bankId,
        'userBankName': userBankName,
        'imgId': imgId,
        'googleChatBankId': googleChatBankId,
      };
}
