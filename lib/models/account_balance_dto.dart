class AccountBalanceDTO {
  final String accountNumber;
  final String accountName;
  final String productName;
  final String acctCurrency;
  final String workingBalance;

  const AccountBalanceDTO({
    required this.accountNumber,
    required this.accountName,
    required this.productName,
    required this.acctCurrency,
    required this.workingBalance,
  });

  factory AccountBalanceDTO.fromJson(Map<String, dynamic> json) {
    return AccountBalanceDTO(
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      acctCurrency: json['acctCurrency'] ?? '',
      productName: json['productName'] ?? '',
      workingBalance: json['workingBalance'] ?? '',
    );
  }
}
