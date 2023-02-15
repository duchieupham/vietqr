class BankCardInsertDTO {
  final String bankTypeId;
  final String userId;
  final String userBankName;
  final String bankAccount;
  final int role;

  const BankCardInsertDTO({
    required this.bankTypeId,
    required this.userId,
    required this.userBankName,
    required this.bankAccount,
    required this.role,
  });

  factory BankCardInsertDTO.fromJson(Map<String, dynamic> json) {
    return BankCardInsertDTO(
      bankTypeId: json['bankTypeId'] ?? '',
      userId: json['userId'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      role: json['role'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankTypeId'] = bankTypeId;
    data['userId'] = userId;
    data['userBankName'] = userBankName;
    data['bankAccount'] = bankAccount;
    data['role'] = role;
    return data;
  }
}
