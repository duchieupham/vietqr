class CustomerVaInsertDTO {
  final String merchantId;
  final String merchantName;
  final String bankId;
  final String userId;
  final String bankAccount;
  final String userBankName;
  final String nationalId;
  final String phoneAuthenticated;
  final String vaNumber;

  const CustomerVaInsertDTO({
    required this.merchantId,
    required this.merchantName,
    required this.bankId,
    required this.userId,
    required this.bankAccount,
    required this.userBankName,
    required this.nationalId,
    required this.phoneAuthenticated,
    required this.vaNumber,
  });

  factory CustomerVaInsertDTO.fromJson(Map<String, dynamic> json) {
    return CustomerVaInsertDTO(
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      bankId: json['bankId'],
      userId: json['userId'],
      bankAccount: json['bankAccount'],
      userBankName: json['userBankName'],
      nationalId: json['nationalId'],
      phoneAuthenticated: json['phoneAuthenticated'],
      vaNumber: json['vaNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['bankId'] = bankId;
    data['userId'] = userId;
    data['bankAccount'] = bankAccount;
    data['userBankName'] = userBankName;
    data['nationalId'] = nationalId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    data['vaNumber'] = vaNumber;
    return data;
  }
}
