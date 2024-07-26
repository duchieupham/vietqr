class QRRecreateDTO {
  final String bankId;
  final String amount;
  final String content;
  final String userId;
  final String terminalCode;
  final String orderId;

  final bool newTransaction;

  const QRRecreateDTO({
    required this.bankId,
    required this.amount,
    required this.content,
    required this.userId,
    required this.terminalCode,
    required this.newTransaction,
    this.orderId = '',
  });

  factory QRRecreateDTO.fromJson(Map<String, dynamic> json) {
    return QRRecreateDTO(
      bankId: json['bankId'] ?? '',
      amount: json['amount'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      newTransaction: json['newTransaction'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['amount'] = amount;
    data['content'] = content;
    data['userId'] = userId;
    data['newTransaction'] = newTransaction;
    data['terminalCode'] = terminalCode;
    data['orderId'] = orderId;
    return data;
  }
}
