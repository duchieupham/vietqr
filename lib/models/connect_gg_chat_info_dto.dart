import 'package:vierqr/features/connect_media/connect_media_screen.dart';

class BankMedia {
  String bankId;
  String bankShortName;
  String bankAccount;
  String bankCode;
  String userBankName;
  String imgId;
  String mediaId;

  BankMedia({
    required this.bankId,
    required this.bankShortName,
    required this.bankAccount,
    required this.bankCode,
    required this.userBankName,
    required this.imgId,
    required this.mediaId,
  });

  factory BankMedia.fromJson(Map<String, dynamic> json, TypeConnect type) {
    String typeJson = '';
    switch (type) {
      case TypeConnect.GG_CHAT:
        typeJson = 'googleChatBankId';
        break;
      case TypeConnect.TELE:
        typeJson = 'telBankId';
        break;
      case TypeConnect.LARK:
        typeJson = 'larkBankId';
        break;
      case TypeConnect.SLACK:
        typeJson = 'slackBankId';
        break;
      case TypeConnect.DISCORD:
        typeJson = 'discordAccountBankId';
        break;
      case TypeConnect.GG_SHEET:
        typeJson = 'googleSheetAccountBankId';
        break;
      default:
        break;
    }
    return BankMedia(
      bankId: json['bankId'],
      bankShortName: json['bankShortName'],
      bankAccount: json['bankAccount'],
      bankCode: json['bankCode'],
      userBankName: json['userBankName'],
      imgId: json['imgId'],
      mediaId: json[typeJson],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankId': bankId,
      'bankShortName': bankShortName,
      'bankAccount': bankAccount,
      'bankCode': bankCode,
      'userBankName': userBankName,
      'imgId': imgId,
      'telBankId': mediaId,
    };
  }
}

class InfoMediaDTO {
  String id;
  String chatId;
  String userId;
  String name;
  List<BankMedia> banks;
  List<String> notificationTypes;
  List<String> notificationContents;

  InfoMediaDTO({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.banks,
    required this.notificationTypes,
    required this.notificationContents,
    required this.name,
  });

  factory InfoMediaDTO.fromJson(Map<String, dynamic> json, TypeConnect type) {
    String typeJson = '';
    switch (type) {
      case TypeConnect.GG_CHAT:
        typeJson = 'webhook';
        break;
      case TypeConnect.TELE:
        typeJson = 'chatId';
        break;
      case TypeConnect.LARK:
        typeJson = 'webhook';
        break;
      case TypeConnect.SLACK:
        typeJson = 'webhook';
        break;
      case TypeConnect.DISCORD:
        typeJson = 'webhook';
        break;
      case TypeConnect.GG_SHEET:
        typeJson = 'webhook';
        break;
      default:
        break;
    }
    return InfoMediaDTO(
      id: json['id'],
      chatId: json[typeJson],
      userId: json['userId'],
      name: json['name'] ?? '-',
      banks: json['banks'] != null
          ? List<BankMedia>.from(
              json['banks'].map((bank) => BankMedia.fromJson(bank, type)))
          : [],
      notificationTypes: json['notificationTypes'] != null
          ? List<String>.from(json['notificationTypes'])
          : [],
      notificationContents: json['notificationContents'] != null
          ? List<String>.from(json['notificationContents'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'userId': userId,
      'banks': banks.map((bank) => bank.toJson()).toList(),
      'notificationTypes': notificationTypes,
      'notificationContents': notificationContents,
      'name': name,
    };
  }
}
