class RegisterAuthenticationDTO {
  final String bankId;
  final String nationalId;
  final String phoneAuthenticated;
  final String bankAccountName;
  final String bankAccount;

  const RegisterAuthenticationDTO({
    required this.bankId,
    required this.nationalId,
    required this.phoneAuthenticated,
    required this.bankAccountName,
    required this.bankAccount,
  });

  factory RegisterAuthenticationDTO.fromJson(Map<String, dynamic> json) {
    return RegisterAuthenticationDTO(
      bankId: json['bankId'] ?? '',
      nationalId: json['nationalId'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['nationalId'] = nationalId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    data['bankAccountName'] = bankAccountName;
    data['bankAccount'] = bankAccount;
    return data;
  }
}
