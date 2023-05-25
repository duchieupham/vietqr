class AccountBankBranchDTO {
  final String bankId;
  final String bankAccount;
  final String userBankName;
  final String bankCode;
  final String bankName;
  final String imgId;
  final int bankType;
  final bool authenticated;

  const AccountBankBranchDTO({
    required this.bankId,
    required this.bankAccount,
    required this.userBankName,
    required this.bankCode,
    required this.bankName,
    required this.imgId,
    required this.bankType,
    required this.authenticated,
  });

  factory AccountBankBranchDTO.fromJson(Map<String, dynamic> json) {
    return AccountBankBranchDTO(
      bankId: json['bankId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      imgId: json['imgId'] ?? '',
      bankType: json['bankType'] ?? 0,
      authenticated: json['authenticated'] ?? false,
    );
  }
}
