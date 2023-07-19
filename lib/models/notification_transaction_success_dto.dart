class NotificationTransactionSuccessDTO {
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
  final String refId;
  final String transactionReceiveId;
  final String content;
  final int status;
  final String transType;

  NotificationTransactionSuccessDTO({
    required this.notificationType,
    required this.traceId,
    required this.bankAccount,
    required this.bankName,
    required this.bankCode,
    required this.amount,
    required this.bankId,
    required this.branchName,
    required this.businessName,
    required this.notificationId,
    required this.time,
    required this.refId,
    required this.transactionReceiveId,
    required this.content,
    required this.status,
    required this.transType,
  });

  factory NotificationTransactionSuccessDTO.fromJson(
      Map<String, dynamic> json) {
    return NotificationTransactionSuccessDTO(
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
      time: json['time'] is String
          ? int.tryParse(json['time'] ?? '')
          : json['time'] ?? 0,
      refId: json['refId'] ?? '',
      transactionReceiveId: json['transactionReceiveId'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] is String
          ? int.tryParse(json['status'] ?? '')
          : json['status'] ?? 0,
      transType: json['transType'] ?? '',
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
    return data;
  }
}
