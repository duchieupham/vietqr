class CustomerVAItemDTO {
  final String customerId;
  final String bankAccount;
  final String merchantId;
  final String merchantName;
  final String id;
  final int unpaidInvoiceAmount;

  CustomerVAItemDTO(
      {required this.customerId,
      required this.bankAccount,
      required this.merchantId,
      required this.merchantName,
      required this.id,
      required this.unpaidInvoiceAmount});

  factory CustomerVAItemDTO.fromJson(Map<String, dynamic> json) {
    return CustomerVAItemDTO(
      customerId: json['customerId'],
      bankAccount: json['bankAccount'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      id: json['id'],
      unpaidInvoiceAmount: json['unpaidInvoiceAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['customerId'] = customerId;
    data['bankAccount'] = bankAccount;
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['id'] = id;
    data['unpaidInvoiceAmount'] = unpaidInvoiceAmount;
    return data;
  }
}
