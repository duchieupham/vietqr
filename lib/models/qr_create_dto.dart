class QRCreateDTO {
  final String bankId;
  final String amount;
  final String content;
  final String userId;
  final String orderId;
  final String terminalCode;

  const QRCreateDTO({
    required this.bankId,
    required this.amount,
    required this.content,
    required this.userId,
    required this.orderId,
    required this.terminalCode,
  });

  factory QRCreateDTO.fromJson(Map<String, dynamic> json) {
    return QRCreateDTO(
      bankId: json['bankId'] ?? '',
      amount: json['amount'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      orderId: json['orderId'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['amount'] = amount;
    data['content'] = content;
    data['userId'] = userId;
    data['orderId'] = orderId;
    data['terminalCode'] = terminalCode;
    return data;
  }
}
