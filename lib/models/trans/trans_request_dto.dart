class TransRequest {
  final String fullName;
  final int requestType;
  final String userId;
  final String merchantId;
  final String terminalId;
  final String merchantName;
  final String transactionId;
  final String requestId;
  final String phoneNumber;
  final String terminalName;
  final String terminalCode;
  int status;

  TransRequest({
    this.fullName = '',
    this.requestType = 0,
    this.userId = '',
    this.merchantId = '',
    this.terminalId = '',
    this.merchantName = '',
    this.transactionId = '',
    this.requestId = '',
    this.phoneNumber = '',
    this.terminalName = '',
    this.terminalCode = '',
    this.status = 0,
  });

  String get nameRequest =>
      'Xác nhận GD thuộc cửa hàng $terminalName ${terminalCode.isNotEmpty ? '($terminalCode)' : ''}';

  factory TransRequest.fromJson(Map<String, dynamic> json) => TransRequest(
    fullName: json["fullName"] ?? '',
    requestType: json["requestType"] ?? 0,
    userId: json["userId"] ?? '',
    merchantId: json["merchantId"] ?? '',
    terminalId: json["terminalId"] ?? '',
    merchantName: json["merchantName"] ?? '',
    transactionId: json["transactionId"] ?? '',
    terminalCode: json["requestValue"] ?? '',
    requestId: json["requestId"] ?? '',
    phoneNumber: json["phoneNumber"] ?? '',
    terminalName: json["terminalName"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "requestType": requestType,
    "userId": userId,
    "merchantId": merchantId,
    "terminalId": terminalId,
    "merchantName": merchantName,
    "transactionId": transactionId,
    "requestValue": terminalCode,
    "requestId": requestId,
    "phoneNumber": phoneNumber,
    "terminalName": terminalName,
  };
}