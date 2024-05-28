import 'dart:convert';

class ActiveQRBoxDTO {
  String qrCode;
  String bankAccount;
  String boxId;
  String bankCode;
  String boxCode;
  String subTerminalCode;
  String subTerminalAddress;

  ActiveQRBoxDTO({
    required this.qrCode,
    required this.bankAccount,
    required this.boxId,
    required this.bankCode,
    required this.boxCode,
    required this.subTerminalCode,
    required this.subTerminalAddress,
  });

  // Factory constructor to create an instance from a JSON map
  factory ActiveQRBoxDTO.fromJson(Map<String, dynamic> json) {
    return ActiveQRBoxDTO(
      qrCode: json['qrCode'],
      bankAccount: json['bankAccount'],
      boxId: json['boxId'],
      bankCode: json['bankCode'],
      boxCode: json['boxCode'],
      subTerminalCode: json['subTerminalCode'],
      subTerminalAddress: json['subTerminalAddress'],
    );
  }

  // Method to convert an instance of this class to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'qrCode': qrCode,
      'bankAccount': bankAccount,
      'boxId': boxId,
      'bankCode': bankCode,
      'boxCode': boxCode,
      'subTerminalCode': subTerminalCode,
      'subTerminalAddress': subTerminalAddress,
    };
  }
}
