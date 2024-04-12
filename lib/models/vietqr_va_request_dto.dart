class VietQRVaRequestDTO {
  final String billId;
  final String userBankName;
  final String amount;
  final String description;

  const VietQRVaRequestDTO({
    required this.billId,
    required this.userBankName,
    required this.amount,
    required this.description,
  });

  factory VietQRVaRequestDTO.fromJson(Map<String, dynamic> json) {
    return VietQRVaRequestDTO(
      billId: json['billId'],
      userBankName: json['userBankName'],
      amount: json['amount'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['billId'] = billId;
    data['userBankName'] = userBankName;
    data['amount'] = amount;
    data['description'] = description;
    return data;
  }
}
