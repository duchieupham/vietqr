class BankCardRequestOTP {
  final String nationalId;
  final String accountNumber;
  final String accountName;
  final String applicationType;

  const BankCardRequestOTP({
    required this.nationalId,
    required this.accountNumber,
    required this.accountName,
    required this.applicationType,
  });

  factory BankCardRequestOTP.fromJson(Map<String, dynamic> json) {
    return BankCardRequestOTP(
      nationalId: json['nationalId'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '',
      applicationType: json['applicationType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['nationalId'] = nationalId;
    data['accountNumber'] = accountNumber;
    data['accountName'] = accountName;
    data['applicationType'] = applicationType;
    return data;
  }
}
