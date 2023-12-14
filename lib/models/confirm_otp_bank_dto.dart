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
