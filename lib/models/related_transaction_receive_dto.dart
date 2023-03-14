class RelatedTransactionReceiveDTO {
  final String bankAccount;
  final String amount;
  final int status;
  final int time;
  final String content;
  final String transactionId;

  const RelatedTransactionReceiveDTO({
    required this.bankAccount,
    required this.amount,
    required this.status,
    required this.time,
    required this.content,
    required this.transactionId,
  });

  factory RelatedTransactionReceiveDTO.fromJson(Map<String, dynamic> json) {
    return RelatedTransactionReceiveDTO(
      bankAccount: json['bankAccount'],
      amount: json['amount'],
      status: json['status'],
      time: json['time'],
      content: json['content'],
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bankAccount'] = bankAccount;
    data['amount'] = amount;
    data['status'] = status;
    data['time'] = time;
    data['content'] = content;
    data['transactionId'] = transactionId;
    return data;
  }
}
