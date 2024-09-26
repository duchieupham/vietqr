class InvoiceFeeDTO {
  String invoiceId;
  String billNumber;
  String invoiceNumber;
  String invoiceName;
  int timeCreated;
  int timePaid;
  int status;
  String bankId;
  String bankAccount;
  String bankShortName;
  String qrCode;
  int totalAmount;
  String fileAttachmentId;
  bool isSelect;

  InvoiceFeeDTO({
    required this.invoiceId,
    required this.billNumber,
    required this.invoiceNumber,
    required this.invoiceName,
    required this.timeCreated,
    required this.timePaid,
    required this.status,
    required this.bankId,
    required this.bankAccount,
    required this.bankShortName,
    required this.qrCode,
    required this.totalAmount,
    required this.fileAttachmentId,
    this.isSelect = false,
  });

  factory InvoiceFeeDTO.fromJson(Map<String, dynamic> json) {
    return InvoiceFeeDTO(
      invoiceId: json['invoiceId'] ?? '',
      billNumber: json['billNumber'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      invoiceName: json['invoiceName'] ?? '',
      timeCreated: json['timeCreated'] ?? 0,
      timePaid: json['timePaid'] ?? 0,
      status: json['status'] ?? 0,
      bankId: json['bankId'] ?? '',
      bankAccount: json['bankAccount'] ?? '',
      bankShortName: json['bankShortName'] ?? '',
      qrCode: json['qrCode'] ?? '',
      totalAmount: json['totalAmount'] ?? 0,
      fileAttachmentId: json['fileAttachmentId'] ?? '',
    );
  }

  void selected(bool value) {
    isSelect = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'billNumber': billNumber,
      'invoiceNumber': invoiceNumber,
      'invoiceName': invoiceName,
      'timeCreated': timeCreated,
      'timePaid': timePaid,
      'status': status,
      'bankId': bankId,
      'bankAccount': bankAccount,
      'bankShortName': bankShortName,
      'qrCode': qrCode,
      'totalAmount': totalAmount,
      'fileAttachmentId': fileAttachmentId ?? '',
    };
  }
}
