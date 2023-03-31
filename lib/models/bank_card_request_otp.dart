class BankCardRequestOTP {
  final String nationalId;
  final String accountNumber;
  final String accountName;
  final String applicationType;
  final String phoneNumber;

  const BankCardRequestOTP({
    required this.nationalId,
    required this.accountNumber,
    required this.accountName,
    required this.applicationType,
    required this.phoneNumber,
  });

  factory BankCardRequestOTP.fromJson(Map<String, dynamic> json) {
    return BankCardRequestOTP(
      nationalId: json['nationalId'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      applicationType: json['applicationType'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['nationalId'] = nationalId;
    data['accountNumber'] = accountNumber;
    data['accountName'] = accountName;
    data['applicationType'] = applicationType;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
