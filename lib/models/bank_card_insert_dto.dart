class BankCardInsertDTO {
  final String bankTypeId;
  final String userId;
  final String userBankName;
  final String bankAccount;
  final String bankCode;
  final int type;
  final String branchId;
  final String nationalId;
  final String phoneAuthenticated;
  final String ewalletToken;
  final String merchantId;
  final String merchantName;
  final String vaNumber;

  const BankCardInsertDTO({
    required this.bankTypeId,
    required this.userId,
    required this.userBankName,
    required this.bankAccount,
    required this.bankCode,
    required this.type,
    required this.branchId,
    required this.nationalId,
    required this.phoneAuthenticated,
    required this.ewalletToken,
    required this.merchantId,
    required this.merchantName,
    required this.vaNumber,
  });

  factory BankCardInsertDTO.fromJson(Map<String, dynamic> json) {
    return BankCardInsertDTO(
      bankTypeId: json['bankTypeId'] ?? '',
      userId: json['userId'] ?? '',
      userBankName: json['userBankName'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankCode: json['bankCode'] ?? '',
      type: json['type'] ?? 0,
      branchId: json['branchId'] ?? '',
      nationalId: json['nationalId'] ?? '',
      phoneAuthenticated: json['phoneAuthenticated'] ?? '',
      ewalletToken: json['ewalletToken'] ?? '',
      merchantId: json['merchantId'] ?? '',
      merchantName: json['merchantName'] ?? '',
      vaNumber: json['vaNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankTypeId'] = bankTypeId;
    data['userId'] = userId;
    data['userBankName'] = userBankName;
    data['bankAccount'] = bankAccount;
    data['bankCode'] = bankCode;
    data['type'] = type;
    data['branchId'] = branchId;
    data['nationalId'] = nationalId;
    data['phoneAuthenticated'] = phoneAuthenticated;
    data['ewalletToken'] = ewalletToken;
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['vaNumber'] = vaNumber;

    return data;
  }
}
