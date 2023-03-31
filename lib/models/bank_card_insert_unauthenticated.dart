class BankCardInsertUnauthenticatedDTO {
  final String bankTypeId;
  final String userId;
  final String userBankName;
  final String bankAccount;

  const BankCardInsertUnauthenticatedDTO({
    required this.bankTypeId,
    required this.userId,
    required this.userBankName,
    required this.bankAccount,
  });

  factory BankCardInsertUnauthenticatedDTO.fromJson(Map<String, dynamic> json) {
    return BankCardInsertUnauthenticatedDTO(
      bankTypeId: json['bankTypeId'] ?? '',
      userId: json['userId'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankTypeId'] = bankTypeId;
    data['userId'] = userId;
    data['userBankName'] = userBankName;
    data['bankAccount'] = bankAccount;
    return data;
  }
}
