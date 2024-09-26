class TransactionInputDTO {
  final String bankId;
  final int offset;
  final int? status;
  final int? type;
  String? from;
  String? to;
  String? value;
  String? userId;
  String terminalCode;

  TransactionInputDTO({
    required this.bankId,
    required this.offset,
    this.status,
    this.type,
    this.from,
    this.to,
    this.value,
    this.userId,
    this.terminalCode = '',
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['offset'] = offset;
    data['terminalCode'] = terminalCode;
    if (status != null) data['status'] = status;
    if (type != null) data['type'] = type;
    if (from != null) data['from'] = from;
    if (to != null) data['to'] = to;
    if (value != null) data['value'] = value;
    return data;
  }
}
