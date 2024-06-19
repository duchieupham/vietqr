class QRCreateDTO {
  final String bankId;
  final String bankCode;
  final String amount;
  final String content;
  final String userId;
  final String orderId;
  final String terminalCode;
  final String subTerminalCode;

  const QRCreateDTO({
    required this.bankId,
    required this.amount,
    required this.content,
    required this.bankCode,
    required this.userId,
    required this.orderId,
    required this.terminalCode,
    required this.subTerminalCode,
  });

  factory QRCreateDTO.fromJson(Map<String, dynamic> json) {
    return QRCreateDTO(
      bankId: json['bankId'] ?? '',
      amount: json['amount'] ?? '',
      content: json['content'] ?? '',
      userId: json['userId'] ?? '',
      bankCode: json['bankCode'] ?? '',
      orderId: json['orderId'] ?? '',
      terminalCode: json['terminalCode'] ?? '',
      subTerminalCode: json['subTerminalCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['amount'] = amount;
    data['content'] = content;
    data['bankCode'] = bankCode;
    data['userId'] = userId;
    data['orderId'] = orderId;
    data['terminalCode'] = terminalCode;
    data['subTerminalCode'] = subTerminalCode;
    // data['bankCode'] = 'BIDV';

    return data;
  }
}
