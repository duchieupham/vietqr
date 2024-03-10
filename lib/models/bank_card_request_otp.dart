class BankCardRequestOTP {
  final String nationalId;
  final String accountNumber;
  final String accountName;
  final String applicationType;
  final String phoneNumber;
  final String bankCode;

  const BankCardRequestOTP({
    required this.nationalId,
    required this.accountNumber,
    required this.accountName,
    required this.applicationType,
    required this.phoneNumber,
    required this.bankCode,
  });

  factory BankCardRequestOTP.fromJson(Map<String, dynamic> json) {
    return BankCardRequestOTP(
      nationalId: json['nationalId'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      applicationType: json['applicationType'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      bankCode: json['bankCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['nationalId'] = nationalId;
    data['accountNumber'] = accountNumber;
    data['accountName'] = accountName;
    data['applicationType'] = applicationType;
    data['phoneNumber'] = phoneNumber;
    data['bankCode'] = bankCode;
    return data;
  }
}
