class CustomerVaRequestDTO {
  final String merchantName;
  final String bankAccount;
  final String bankCode;
  final String userBankName;
  final String nationalId;
  final String phoneAuthenticated;

  CustomerVaRequestDTO(
      {required this.merchantName,
      required this.bankAccount,
      required this.bankCode,
      required this.userBankName,
      required this.nationalId,
      required this.phoneAuthenticated});

  factory CustomerVaRequestDTO.fromJson(Map<String, dynamic> json) {
    return CustomerVaRequestDTO(
      merchantName: json['merchantName'],
      bankAccount: json['bankAccount'],
      bankCode: json['bankCode'],
      userBankName: json['userBankName'],
      nationalId: json['nationalId'],
      phoneAuthenticated: json['phoneAuthenticated'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchantName'] = merchantName;
    data['bankAccount'] = bankAccount;
    data['bankCode'] = bankCode;
    data['userBankName'] = userBankName;
    data['nationalId'] = nationalId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    return data;
  }
}
