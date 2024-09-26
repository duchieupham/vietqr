class TransactionReceiveDashBoardDTO {
  final String amount;
  final String bankAccount;
  final int time;
  final int status;

  const TransactionReceiveDashBoardDTO({
    required this.amount,
    required this.bankAccount,
    required this.time,
    required this.status,
  });
}
