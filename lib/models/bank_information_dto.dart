class BankInformationDTO {
  final String address;
  final String time;
  final String transaction;
  final String accountBalance;
  final String content;
  final String bankAccount;

  const BankInformationDTO({
    required this.address,
    required this.time,
    required this.transaction,
    required this.accountBalance,
    required this.content,
    required this.bankAccount,
  });
}
