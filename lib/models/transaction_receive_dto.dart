import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/transaction_utils.dart';

class TransactionReceiveDTO {
  final String bankId;
  final String bankAccount;
  final String bankCode;
  final String bankShortName;
  final String bankAccountName;
  final int time;
  final int timePaid;
  final int status;
  final String id;
  final int type;
  final String content;
  final String bankName;
  final String imgId;
  final String amount;
  final String transType;
  final String traceId;
  final String refId;
  final String referenceNumber;
  final String note;
  final String orderId;
  final String terminalCode;

  const TransactionReceiveDTO({
    required this.time,
    required this.timePaid,
    required this.status,
    required this.id,
    required this.type,
    required this.content,
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankShortName,
    required this.bankId,
    required this.bankCode,
    required this.bankName,
    required this.imgId,
    required this.amount,
    required this.transType,
    required this.traceId,
    required this.refId,
    required this.referenceNumber,
    required this.note,
    required this.orderId,
    required this.terminalCode,
  });

  String get getTransType => TransactionUtils.instance.getTransType(transType);

  String get getPrefixBankAccount =>
      TransactionUtils.instance.getPrefixBankAccount(transType);

  String get getStatus => TransactionUtils.instance.getStatusString(status);

  String get getAmount => amount;

  // type = 0: Giao dịch có đối soát, tạo bằng mã VietQR động.
  // type = 1: Giao dịch có đối soát, tạo bằng mã VietQR tĩnh.
  // type = 2: Giao dịch không có đối soát.
  //
  //
  // Màu giao dịch:
  // - type = 0, transType = C: màu xanh lá
  // - type = 1, transType = C: màu xanh lá
  // - type = 4, transType = C: màu xanh lá
  // - type = 5, transType = C: màu xanh lá
  //
  // - transType = D: màu đỏ
  //
  // - type = 2, transType = C: xanh xanh dương
  //
  //
  // Loại giao dịch (hiển thị ngoài UI):
  // - type = 0: VietQR động
  // - type = 1: VietQR tĩnh
  // - type = 2: Khác.

  bool isTimeTT() {
    return (status == 1 && type == 1 && (transType == 'D' || transType == 'C'));

    return false;
  }

  String getTitleType() {
    if (type == 0) {
      return 'VietQR giao dịch';
    } else if (type == 1) {
      return 'VietQR cửa hàng';
    } else {
      return 'Khác';
    }
  }

  Color get getColorStatus {
    if (transType.trim() == 'D') return AppColor.RED_CALENDAR;

    if (status == 0) return AppColor.ORANGE_DARK;

    if (status == 1 && type == 2) return AppColor.BLUE_TEXT;

    if (status == 1 && (type == 0 || type == 4 || type == 5 || type == 1)) {
      return AppColor.GREEN;
    }

    if (status == 2) return AppColor.GREY_TEXT;

    return AppColor.TRANSPARENT;
  }

  factory TransactionReceiveDTO.fromJson(Map<String, dynamic> json) {
    return TransactionReceiveDTO(
      time: json['time'] ?? 0,
      timePaid: json['timePaid'] ?? 0,
      status: json['status'] ?? 0,
      id: json['id'] ?? '',
      type: json['type'] ?? 0,
      content: json['content'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      bankId: json['bankId'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      amount: json['amount'] ?? 0,
      transType: json['transType'] ?? '',
      traceId: json['traceId'] ?? '',
      refId: json['refId'] ?? '',
      referenceNumber: json['referenceNumber'] ?? '',
      note: json['note'] ?? '',
      orderId: json['orderId'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['time'] = time;
    data['timePaid'] = timePaid;
    data['status'] = status;
    data['id'] = id;
    data['type'] = type;
    data['content'] = content;
    data['bankAccount'] = bankAccount;
    data['bankAccountName'] = bankAccountName;
    data['bankId'] = bankId;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['imgId'] = imgId;
    data['amount'] = amount;
    data['transType'] = transType;
    data['traceId'] = traceId;
    data['refId'] = refId;
    data['referenceNumber'] = referenceNumber;
    return data;
  }
}
