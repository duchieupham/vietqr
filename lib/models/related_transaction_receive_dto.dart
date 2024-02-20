import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class RelatedTransactionReceiveDTO {
  final String bankAccount;
  final String amount;
  final int status;
  final int time;
  final int timePaid;
  final String content;
  final String transactionId;
  final int type;
  final String transType;

  const RelatedTransactionReceiveDTO({
    required this.bankAccount,
    required this.amount,
    required this.status,
    required this.time,
    required this.timePaid,
    required this.content,
    required this.transactionId,
    required this.type,
    required this.transType,
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

  factory RelatedTransactionReceiveDTO.fromJson(Map<String, dynamic> json) {
    return RelatedTransactionReceiveDTO(
      bankAccount: json['bankAccount'] ?? '',
      amount: json['amount'] ?? '',
      status: json['status'] ?? 0,
      time: json['time'] ?? 0,
      timePaid: json['timePaid'] ?? 0,
      content: json['content'] ?? '',
      transactionId: json['transactionId'] ?? '',
      type: json['type'] ?? 0,
      transType: json['transType'] ?? '',
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
