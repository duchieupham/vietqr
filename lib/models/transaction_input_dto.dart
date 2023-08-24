class TransactionInputDTO {
  final String bankId;
  final int offset;
  final int? status;

  const TransactionInputDTO({
    required this.bankId,
    required this.offset,
    this.status,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['offset'] = offset;
    if (status != null) data['status'] = status;
    return data;
  }
}
