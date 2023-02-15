class BankCardGeneratedDTO {
  final String imgId;
  final String bankCode;
  final String bankName;
  final int role;
  final String bankAccount;
  final String userBankName;

  const BankCardGeneratedDTO({
    required this.imgId,
    required this.bankCode,
    required this.bankName,
    required this.bankAccount,
    required this.userBankName,
    required this.role,
  });
}
