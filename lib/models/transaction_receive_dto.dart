import 'package:vierqr/commons/utils/currency_utils.dart';
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
  final int amount;
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

  String get getAmount =>
      CurrencyUtils.instance.getCurrencyFormatted(amount.toString());

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
