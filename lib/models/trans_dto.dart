import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class TransDTO {
  final String transactionId;
  final String amount;
  final String bankAccount;
  final String content;
  final int time;
  final int timePaid;
  final int status;
  final int type;
  final String transType;
  final String terminalCode;
  final String note;
  final String referenceNumber;
  final String orderId;
  final String bankShortName;

  const TransDTO({
    this.bankAccount = '',
    this.amount = '',
    this.status = -1,
    this.time = 0,
    this.timePaid = 0,
    this.content = '',
    this.transactionId = '',
    this.type = -1,
    this.transType = '',
    this.terminalCode = '',
    this.note = '',
    this.referenceNumber = '',
    this.orderId = '',
    this.bankShortName = '',
  });

  bool get isTimeTT {
    if (transType.trim() == 'D' ||
        (transType.trim() == 'C' &&
            (status == 1 &&
                (type == 0 ||
                    type == 1 ||
                    type == 2 ||
                    type == 4 ||
                    type == 5)))) {
      return true;
    }
    return false;
  }

  bool get isTimeCreate {
    if (transType.trim() == 'C' && (status == 2 || status == 0 || type == 0)) {
      return true;
    }
    return false;
  }

  Color get getColorStatus {
    if (transType.trim() == 'D') return AppColor.RED_CALENDAR;

    if (status == 0) return AppColor.ORANGE_DARK;

    if (status == 1 && type == 2) return AppColor.BLUE_TEXT;

    if (status == 1 && (type == 0 || type == 1 || type == 4 || type == 5)) {
      return AppColor.GREEN;
    }

    if (status == 2) return AppColor.GREY_TEXT;

    return AppColor.TRANSPARENT;
  }

  factory TransDTO.fromJson(Map<String, dynamic> json) {
    return TransDTO(
      transactionId: json['transactionId'] ?? '',
      amount: json['amount'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      content: json['content'] ?? '',
      time: json['time'] ?? 0,
      timePaid: json['timePaid'] ?? 0,
      status: json['status'] ?? 0,
      type: json['type'] ?? 0,
      transType: json['transType'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      note: json['note'] ?? '',
      referenceNumber: json['referenceNumber'] ?? '',
      orderId: json['referenceNumber'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankAccount'] = bankAccount;
    data['amount'] = amount;
    data['status'] = status;
    data['time'] = time;
    data['timePaid'] = timePaid;
    data['content'] = content;
    data['transactionId'] = transactionId;
    data['transType'] = transType;
    return data;
  }
}
