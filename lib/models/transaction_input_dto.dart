class TransactionInputDTO {
  final String bankId;
  final int offset;

  const TransactionInputDTO({
    required this.bankId,
    required this.offset,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['offset'] = offset;
    return data;
  }
}
