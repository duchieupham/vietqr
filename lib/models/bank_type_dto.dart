class BankTypeDTO {
  final String id;
  final String bankCode;
  final String bankName;
  final String? bankShortName;
  final String imageId;
  final int status;
  final String caiValue;

  const BankTypeDTO({
    required this.id,
    required this.bankCode,
    required this.bankName,
    this.bankShortName,
    required this.imageId,
    required this.status,
    required this.caiValue,
  });

  get name => '${(bankShortName ?? '')} - $bankName';

  factory BankTypeDTO.fromJson(Map<String, dynamic> json) {
    return BankTypeDTO(
      id: json['id'] ?? '',
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      imageId: json['imageId'] ?? '',
      status: json['status'] ?? 0,
      caiValue: json['caiValue'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['bankCode'] = bankCode;
    data['bankName'] = bankName;
    data['imageId'] = imageId;
    data['status'] = status;
    data['caiValue'] = caiValue;
    return data;
  }
}
