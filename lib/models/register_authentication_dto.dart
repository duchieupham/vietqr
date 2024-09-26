class RegisterAuthenticationDTO {
  final String bankId;
  final String bankCode;
  final String merchantId;
  final String merchantName;
  final String vaNumber;
  final String nationalId;
  final String phoneAuthenticated;
  final String bankAccountName;
  final String bankAccount;
  final String ewalletToken;

  const RegisterAuthenticationDTO({
    required this.bankId,
    required this.bankCode,
    required this.merchantId,
    required this.merchantName,
    required this.vaNumber,
    required this.nationalId,
    required this.phoneAuthenticated,
    required this.bankAccountName,
    required this.bankAccount,
    required this.ewalletToken,
  });

  factory RegisterAuthenticationDTO.fromJson(Map<String, dynamic> json) {
    return RegisterAuthenticationDTO(
      bankId: json['bankId'] ?? '',
      bankCode: json['bankCode'] ?? '',
      merchantId: json['merchantId'] ?? '',
      merchantName: json['merchantName'] ?? '',
      vaNumber: json['vaNumber'] ?? '',
      nationalId: json['nationalId'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      ewalletToken: json['ewalletToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['bankCode'] = bankCode;
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['vaNumber'] = vaNumber;
    data['nationalId'] = nationalId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    data['bankAccountName'] = bankAccountName;
    data['bankAccount'] = bankAccount;
    data['ewalletToken'] = '';
    return data;
  }
}
