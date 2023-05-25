class AccountBankConnectBranchDTO {
  final String bankId;
  final String bankAccount;
  final String bankAccountName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final String userId;
  final bool authenticated;

  const AccountBankConnectBranchDTO({
    required this.bankId,
    required this.bankAccount,
    required this.bankAccountName,
    required this.bankCode,
    required this.bankName,
    required this.imgId,
    required this.userId,
    required this.authenticated,
  });

  factory AccountBankConnectBranchDTO.fromJson(Map<String, dynamic> json) {
    return AccountBankConnectBranchDTO(
      bankId: json['bankId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      userId: json['userId'] ?? '',
      authenticated: json['authenticated'] ?? false,
    );
  }
}
