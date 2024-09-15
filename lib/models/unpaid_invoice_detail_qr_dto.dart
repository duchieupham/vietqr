class UnpaidInvoiceDetailQrDTO {
  String qrCode;
  int totalAmountAfterVat;
  String invoiceName;
  String midName;
  String vso;
  String bankCode;
  String bankName;
  String bankAccount;
  String bankShortName;
  String invoiceNumber;
  String userBankName;
  int totalAmount;
  double vat;
  int vatAmount;
  String invoiceId;
  String urlLink;
  int expiredTime;

  UnpaidInvoiceDetailQrDTO({
    required this.qrCode,
    required this.totalAmountAfterVat,
    required this.invoiceName,
    required this.midName,
    required this.vso,
    required this.bankCode,
    required this.bankName,
    required this.bankAccount,
    required this.bankShortName,
    required this.invoiceNumber,
    required this.userBankName,
    required this.totalAmount,
    required this.vat,
    required this.vatAmount,
    required this.invoiceId,
    required this.urlLink,
    required this.expiredTime,
  });

  factory UnpaidInvoiceDetailQrDTO.fromJson(Map<String, dynamic> json) {
    return UnpaidInvoiceDetailQrDTO(
      qrCode: json['qrCode'],
      totalAmountAfterVat: json['totalAmountAfterVat'],
      invoiceName: json['invoiceName'],
      midName: json['midName'],
      vso: json['vso'],
      bankCode: json['bankCode'] ?? '',
      bankName: json['bankName'] ?? '',
      bankAccount: json['bankAccount'],
      bankShortName: json['bankShortName'],
      invoiceNumber: json['invoiceNumber'],
      userBankName: json['userBankName'],
      totalAmount: json['totalAmount'],
      vat: json['vat'],
      vatAmount: json['vatAmount'],
      invoiceId: json['invoiceId'],
      urlLink: json['urlLink'],
      expiredTime: json['expiredTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qrCode'] = qrCode;
    data['totalAmountAfterVat'] = totalAmountAfterVat;
    data['invoiceName'] = invoiceName;
    data['midName'] = midName;
    data['vso'] = vso;
    data['bankAccount'] = bankAccount;
    data['bankShortName'] = bankShortName;
    data['invoiceNumber'] = invoiceNumber;
    data['userBankName'] = userBankName;
    data['totalAmount'] = totalAmount;
    data['vat'] = vat;
    data['vatAmount'] = vatAmount;
    data['invoiceId'] = invoiceId;
    data['urlLink'] = urlLink;

    data['expiredTime'] = expiredTime;
    return data;
  }
}
