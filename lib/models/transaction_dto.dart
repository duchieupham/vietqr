class TransactionDTO {
  final String id;
  final String accountBalance;
  final String address;
  final String bankAccount;
  final String bankId;
  final String content;
  final bool isFormatted;
  final String status;
  final dynamic timeInserted;
  final String timeReceived;
  final String transaction;
  final String type;
  final String userId;

  const TransactionDTO({
    required this.id,
    required this.accountBalance,
    required this.address,
    required this.bankAccount,
    required this.bankId,
    required this.content,
    required this.isFormatted,
    required this.status,
    required this.timeInserted,
    required this.timeReceived,
    required this.transaction,
    required this.type,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['accountBalance'] = accountBalance;
    data['address'] = address;
    data['bankAccount'] = bankAccount;
    data['bankId'] = bankId;
    data['content'] = content;
    data['isFormatted'] = isFormatted;
    data['status'] = status;
    data['timeCreated'] = timeInserted;
    data['timeReceived'] = timeReceived;
    data['transaction'] = transaction;
    data['type'] = type;
    data['userId'] = userId;
    return data;
  }
}
