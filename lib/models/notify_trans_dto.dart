import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';

class NotifyTransDTO {
  final String notificationType;
  final String traceId;
  final String bankAccount;
  final String bankName;
  final String bankCode;
  final String amount;
  final String bankId;
  final String branchName;
  final String businessName;
  final String notificationId;
  final int time;
  final int timePaid;
  final String refId;
  final String transactionReceiveId;
  final String content;
  final int status;
  final String transType;
  final String audioLink;
  String terminalName;
  String terminalCode;
  final String rawTerminalCode;
  final String orderId;
  final String referenceNumber;

  NotifyTransDTO({
    this.notificationType = '',
    this.traceId = '',
    this.bankAccount = '',
    this.bankName = '',
    this.bankCode = '',
    this.amount = '',
    this.bankId = '',
    this.branchName = '',
    this.businessName = '',
    this.notificationId = '',
    this.time = 0,
    this.timePaid = 0,
    this.refId = '',
    this.transactionReceiveId = '',
    this.content = '',
    this.status = 0,
    this.transType = '',
    this.audioLink = '',
    this.terminalName = '',
    this.terminalCode = '',
    this.rawTerminalCode = '',
    this.orderId = '',
    this.referenceNumber = '',
  });

  String get getTransStatus => 'Giao dịch thành công';

  String get getTransType => (transType.trim() == 'C') ? '+' : '-';

  String get getAmount =>
      '$getTransType ${amount.contains('*') ? amount : CurrencyUtils.instance.getCurrencyFormatted(amount)} VND';

  Color get colorAmount => (transType.trim() == 'C')
      ? isTransUnclassified
          ? AppColor.BLUE_TEXT
          : AppColor.GREEN
      : AppColor.RED_CALENDAR;

  String get timePayment => timePaid == 0
      ? '-'
      : DateFormat('dd/MM/yyyy HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(timePaid * 1000));

  String get getTimeCreate => time == 0
      ? '-'
      : DateFormat('dd/MM/yyyy HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(time * 1000));

  ///
  bool get isTerNotEmpty => terminalName.isNotEmpty || terminalCode.isNotEmpty;

  bool get isTerEmpty => terminalName.isEmpty && terminalCode.isEmpty;

  bool get isTransUnclassified =>
      terminalName.isEmpty && terminalCode.isEmpty && orderId.isEmpty;

  String get icon => (transType.trim() == 'C')
      ? isTransUnclassified
          ? AppImages.icSuccessInBlue
          : AppImages.icSuccessInGreen
      : AppImages.icSuccessOut;

  factory NotifyTransDTO.fromJson(Map<String, dynamic> json) {
    return NotifyTransDTO(
      notificationType: json['notificationType'] ?? '',
      traceId: json['traceId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankName: json['bankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      amount: json['amount'] ?? '',
      bankId: json['bankId'] ?? '',
      branchName: json['branchName'] ?? '',
      businessName: json['businessName'] ?? '',
      notificationId: json['notificationId'] ?? '',
      time: int.tryParse(json['time'] ?? '') ?? 0,
      timePaid: int.tryParse(json['timePaid'] ?? '') ?? 0,
      refId: json['refId'] ?? '',
      transactionReceiveId: json['transactionReceiveId'] ?? '',
      content: json['content'] ?? '',
      status: int.tryParse(json['status'] ?? '') ?? 0,
      transType: json['transType'] ?? '',
      audioLink: json['audioLink'] ?? '',
      terminalName: json["terminalName"] ?? '',
      terminalCode: json["terminalCode"] ?? '',
      rawTerminalCode: json["rawTerminalCode"] ?? '',
      orderId: json["orderId"] ?? '',
      referenceNumber: json["referenceNumber"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['notificationType'] = notificationType;
    data['traceId'] = traceId;
    data['bankAccount'] = bankAccount;
    data['bankName'] = bankName;
    data['bankCode'] = bankCode;
    data['amount'] = amount;
    data['bankId'] = bankId;
    data['branchName'] = branchName;
    data['businessName'] = businessName;
    data['notificationId'] = notificationId;
    data['time'] = time;
    data['refId'] = refId;
    data['transactionReceiveId'] = transactionReceiveId;
    data['content'] = content;
    data['status'] = status;
    data['transType'] = transType;
    data['audioLink'] = audioLink;
    return data;
  }
}
