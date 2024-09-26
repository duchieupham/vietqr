// {
//     "requestId":"RV-b28f267b-d19d-45ae-99dc-56c177b21083",
//     "otpValue":"20823642",
//     "authenType":"SMS",
//     "applicationType":"MOBILE"
// }

class ConfirmOTPBankDTO {
  final String requestId;
  final String otpValue;
  final String applicationType;
  final String? bankAccount;
  final String? bankCode;

  const ConfirmOTPBankDTO({
    required this.requestId,
    required this.otpValue,
    required this.applicationType,
    this.bankAccount,
    this.bankCode,
  });

  factory ConfirmOTPBankDTO.fromJson(Map<String, dynamic> json) {
    return ConfirmOTPBankDTO(
      requestId: json['requestId'] ?? '',
      otpValue: json['otpValue'] ?? '',
      applicationType: json['applicationType'] ?? '',
      bankCode: json['bankCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['requestId'] = requestId;
    data['otpValue'] = otpValue;
    data['applicationType'] = applicationType;
    if (bankAccount != null) data['bankAccount'] = bankAccount;
    if (bankCode != null) data['bankCode'] = bankCode;

    return data;
  }
}

class ConfirmOTPUnlinkTypeBankDTO {
  String ewalletToken;
  String bankAccount;
  String bankCode;

  ConfirmOTPUnlinkTypeBankDTO({
    required this.ewalletToken,
    required this.bankAccount,
    required this.bankCode,
  });

  // Factory method to create an instance from JSON
  factory ConfirmOTPUnlinkTypeBankDTO.fromJson(Map<String, dynamic> json) {
    return ConfirmOTPUnlinkTypeBankDTO(
      ewalletToken: json['ewalletToken'] ?? '',
      bankAccount: json['bankAccount'],
      bankCode: json['bankCode'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ewalletToken': ewalletToken,
      'bankAccount': bankAccount,
      'bankCode': 'BIDV',
    };
  }
}

class ConfirmOTPBidvDTO {
  String bankCode;
  String bankAccount;
  String merchantId;
  String merchantName;
  String confirmId;
  String otpNumber;

  ConfirmOTPBidvDTO({
    required this.bankCode,
    required this.bankAccount,
    required this.merchantId,
    required this.merchantName,
    required this.confirmId,
    required this.otpNumber,
  });

  // Factory method to create an instance from JSON
  factory ConfirmOTPBidvDTO.fromJson(Map<String, dynamic> json) {
    return ConfirmOTPBidvDTO(
      bankCode: json['bankCode'],
      bankAccount: json['bankAccount'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      confirmId: json['confirmId'],
      otpNumber: json['otpNumber'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'bankCode': bankCode,
      'bankAccount': bankAccount,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'confirmId': confirmId,
      'otpNumber': otpNumber,
    };
  }
}
