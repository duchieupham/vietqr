class VietQRScannedDTO {
  final String caiValue;
  final String bankAccount;

  const VietQRScannedDTO({
    required this.caiValue,
    required this.bankAccount,
  });

  factory VietQRScannedDTO.fromJson(Map<String, dynamic> json) {
    return VietQRScannedDTO(
      caiValue: json['caiValue'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['caiValue'] = caiValue;
    data['bankAccount'] = bankAccount;
    return data;
  }
}
