class QRCreateDTO {
  final String bankId;
  final String amount;
  final String content;
  final String branchId;
  final String businessId;

  const QRCreateDTO({
    required this.bankId,
    required this.amount,
    required this.content,
    required this.branchId,
    required this.businessId,
  });

  factory QRCreateDTO.fromJson(Map<String, dynamic> json) {
    return QRCreateDTO(
      bankId: json['bankId'] ?? '',
      amount: json['amount'] ?? '',
      content: json['content'] ?? '',
      businessId: json['businessId'] ?? '',
      branchId: json['branchId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['bankId'] = bankId;
    data['amount'] = amount;
    data['content'] = content;
    data['businessId'] = businessId;
    data['branchId'] = branchId;
    return data;
  }
}
