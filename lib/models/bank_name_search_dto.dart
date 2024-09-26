class BankNameSearchDTO {
  final String accountNumber;
  final String accountType;
  final String transferType;
  final String bankCode;

  const BankNameSearchDTO({
    required this.accountNumber,
    required this.accountType,
    required this.transferType,
    required this.bankCode,
  });

  factory BankNameSearchDTO.fromJson(Map<String, dynamic> json) {
    return BankNameSearchDTO(
      accountNumber: json['accountNumber'],
      accountType: json['accountType'],
      transferType: json['transferType'],
      bankCode: json['bankCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['accountNumber'] = accountNumber;
    data['accountType'] = accountType;
    data['transferType'] = transferType;
    data['bankCode'] = bankCode;
    return data;
  }
}
