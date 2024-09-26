class CustomerVaConfirmDTO {
  final String merchantId;
  final String merchantName;
  final String confirmId;
  final String otpNumber;

  CustomerVaConfirmDTO({
    required this.merchantId,
    required this.merchantName,
    required this.confirmId,
    required this.otpNumber,
  });

  factory CustomerVaConfirmDTO.fromJson(Map<String, dynamic> json) {
    return CustomerVaConfirmDTO(
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      confirmId: json['confirmId'],
      otpNumber: json['otpNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['confirmId'] = confirmId;
    data['otpNumber'] = otpNumber;
    return data;
  }
}
