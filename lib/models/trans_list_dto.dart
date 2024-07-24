import 'dart:convert';

class TransactionItemDTO {
  String transactionId;
  String amount;
  String content;
  String qrCode;
  int time;
  int timePaid;
  int status;
  int type;
  String transType;
  String referenceNumber;
  String orderId;
  String bankAccount;
  String userBankName;
  String bankCode;
  String bankName;
  String imgId;
  String bankShortName;

  TransactionItemDTO({
    required this.transactionId,
    required this.amount,
    required this.content,
    required this.qrCode,
    required this.time,
    required this.timePaid,
    required this.status,
    required this.type,
    required this.transType,
    required this.referenceNumber,
    required this.orderId,
    required this.bankAccount,
    required this.userBankName,
    required this.bankCode,
    required this.bankName,
    required this.imgId,
    required this.bankShortName,
  });

  factory TransactionItemDTO.fromJson(Map<String, dynamic> json) {
    return TransactionItemDTO(
      transactionId: json['transactionId'],
      amount: json['amount'],
      content: json['content'],
      qrCode: json['qrCode'],
      time: json['time'],
      timePaid: json['timePaid'],
      status: json['status'],
      type: json['type'],
      transType: json['transType'],
      referenceNumber: json['referenceNumber'],
      orderId: json['orderId'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      imgId: json['imgId'],
      bankShortName: json['bankShortName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'amount': amount,
      'content': content,
      'qrCode': qrCode,
      'time': time,
      'timePaid': timePaid,
      'status': status,
      'type': type,
      'transType': transType,
      'referenceNumber': referenceNumber,
      'orderId': orderId,
      'bankAccount': bankAccount,
      'userBankName': userBankName,
      'bankCode': bankCode,
      'bankName': bankName,
      'imgId': imgId,
      'bankShortName': bankShortName,
    };
  }
}

class TransactionItemDetailDTO {
  String id;
  String amount;
  String bankId;
  String bankAccount;
  String bankName;
  String bankCode;
  String content;
  int status;
  int time;
  int timePaid;
  int type;
  String transType;
  String userBankName;
  String imgId;
  String referenceNumber;
  String terminalCode;
  String note;
  String orderId;
  String bankShortName;
  String serviceCode;
  String hashTag;
  String qrCode;

  TransactionItemDetailDTO({
    required this.id,
    required this.amount,
    required this.bankId,
    required this.bankAccount,
    required this.bankName,
    required this.bankCode,
    required this.content,
    required this.status,
    required this.time,
    required this.timePaid,
    required this.type,
    required this.transType,
    required this.userBankName,
    required this.imgId,
    required this.referenceNumber,
    required this.terminalCode,
    required this.note,
    required this.orderId,
    required this.bankShortName,
    required this.serviceCode,
    required this.hashTag,
    required this.qrCode,
  });

  factory TransactionItemDetailDTO.fromJson(Map<String, dynamic> json) {
    return TransactionItemDetailDTO(
      id: json['id'],
      amount: json['amount'],
      bankId: json['bankId'],
      bankAccount: json['bankAccount'],
      bankName: json['bankName'],
      bankCode: json['bankCode'],
      content: json['content'],
      status: json['status'],
      time: json['time'],
      timePaid: json['timePaid'],
      type: json['type'],
      transType: json['transType'],
      userBankName: json['userBankName'],
      imgId: json['imgId'],
      referenceNumber: json['referenceNumber'],
      terminalCode: json['terminalCode'],
      note: json['note'],
      orderId: json['orderId'],
      bankShortName: json['bankShortName'],
      serviceCode: json['serviceCode'],
      hashTag: json['hashTag'],
      qrCode: json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'bankId': bankId,
      'bankAccount': bankAccount,
      'content': content,
      'status': status,
      'time': time,
      'timePaid': timePaid,
      'type': type,
      'transType': transType,
      'userBankName': userBankName,
      'imgId': imgId,
      'referenceNumber': referenceNumber,
      'terminalCode': terminalCode,
      'note': note,
      'orderId': orderId,
      'bankShortName': bankShortName,
      'serviceCode': serviceCode,
      'hashTag': hashTag,
      'qrCode': qrCode,
    };
  }
}

void main() {
  String jsonString =
      '{"id": "002144b1-2609-4677-8b4e-a3573589bf3d", "amount": "123,456,789", "bankId": "9dea5eac-6fc9-4b92-a6ec-22a7f3fa8178", "bankAccount": "0373568944", "content": "gsf Ma giao dich  Trace444952 Trace 444952", "status": 1, "time": 1720688195, "timePaid": 1720688195, "type": 2, "transType": "C", "userBankName": "Cong ty Co Phan SaB", "imgId": "58b7190b-a294-4b14-968f-cd365593893e", "referenceNumber": "FT24140018060", "terminalCode": "Hello", "note": "OKeq1324", "orderId": "12345", "bankShortName": "MBBank", "serviceCode": "BILEEO", "hashTag": "#thu_phi", "qrCode": "00020101021138540010A00000072701240006970422011003735689440208QRIBFTTA530370454091234567895802VN62460842gsf Ma giao dich  Trace444952 Trace 444952630429D4"}';

  // Decode JSON to Dart object
  TransactionItemDetailDTO transaction =
      TransactionItemDetailDTO.fromJson(jsonDecode(jsonString));

  // Encode Dart object to JSON
  String encodedJson = jsonEncode(transaction);
  print(encodedJson);
}

class TransExtraData {
  int totalCredit;
  int totalDebit;

  TransExtraData({required this.totalCredit, required this.totalDebit});

  factory TransExtraData.fromJson(Map<String, dynamic> json) {
    return TransExtraData(
      totalCredit: json['totalCredit'],
      totalDebit: json['totalDebit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
    };
  }
}
