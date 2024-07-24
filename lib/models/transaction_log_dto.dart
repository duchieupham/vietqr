class TransactionLogDTO {
  String id;
  int type;
  String transactionId;
  String status;
  int statusCode;
  String message;
  int timeRequest;
  int timeResponse;
  bool isReaMore;

  TransactionLogDTO({
    required this.id,
    required this.type,
    required this.transactionId,
    required this.status,
    required this.statusCode,
    required this.message,
    required this.timeRequest,
    required this.timeResponse,
    this.isReaMore = false,
  });

  factory TransactionLogDTO.fromJson(Map<String, dynamic> json) {
    return TransactionLogDTO(
      id: json['id'],
      type: json['type'],
      transactionId: json['transactionId'],
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      timeRequest: json['timeRequest'],
      timeResponse: json['timeResponse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'transactionId': transactionId,
      'status': status,
      'statusCode': statusCode,
      'message': message,
      'timeRequest': timeRequest,
      'timeResponse': timeResponse,
    };
  }
}
