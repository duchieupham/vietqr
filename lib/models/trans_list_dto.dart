import 'dart:convert';

import 'package:vierqr/models/metadata_dto.dart';

class TransactionWithExtraDTO {
  MetaDataDTO metadata;
  TransData data;

  TransactionWithExtraDTO({required this.metadata, required this.data});

  factory TransactionWithExtraDTO.fromJson(Map<String, dynamic> json) {
    return TransactionWithExtraDTO(
      metadata: MetaDataDTO.fromJson(json['metadata']),
      data: TransData.fromJson(json['data']),
    );
  }
}

class TransData {
  List<TransItem> items;
  TransExtraData extraData;

  TransData({required this.items, required this.extraData});

  factory TransData.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<TransItem> itemsList = list.map((i) => TransItem.fromJson(i)).toList();

    return TransData(
      items: itemsList,
      extraData: TransExtraData.fromJson(json['extraData']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'extraData': extraData.toJson(),
    };
  }
}

class TransItem {
  String transactionId;
  String amount;
  String qrCode;
  int time;
  int timePaid;
  int status;
  int type;
  String transType;
  String referenceNumber;
  String orderId;

  TransItem({
    required this.transactionId,
    required this.amount,
    required this.qrCode,
    required this.time,
    required this.timePaid,
    required this.status,
    required this.type,
    required this.transType,
    required this.referenceNumber,
    required this.orderId,
  });

  factory TransItem.fromJson(Map<String, dynamic> json) {
    return TransItem(
      transactionId: json['transactionId'],
      amount: json['amount'],
      qrCode: json['qrCode'],
      time: json['time'],
      timePaid: json['timePaid'],
      status: json['status'],
      type: json['type'],
      transType: json['transType'],
      referenceNumber: json['referenceNumber'],
      orderId: json['orderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'amount': amount,
      'qrCode': qrCode,
      'time': time,
      'timePaid': timePaid,
      'status': status,
      'type': type,
      'transType': transType,
      'referenceNumber': referenceNumber,
      'orderId': orderId,
    };
  }
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
