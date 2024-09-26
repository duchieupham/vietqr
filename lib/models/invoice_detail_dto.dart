class InvoiceDetailDTO {
  String? invoiceId;
  String? billNumber;
  String? invoiceNumber;
  String? invoiceName;
  int? timeCreated;
  int? timePaid;
  int? status;
  int? vatAmount;
  int? amount;
  double? vat;
  String? bankId;
  String? bankAccount;
  String? bankShortName;
  String? bankCode;
  String? bankName;
  String? userBankName;
  String? qrCode;
  int? totalAmount;
  List<Items>? items;
  String? fileAttachmentId;

  InvoiceDetailDTO({
    this.invoiceId,
    this.billNumber,
    this.invoiceNumber,
    this.invoiceName,
    this.timeCreated,
    this.timePaid,
    this.status,
    this.vatAmount,
    this.amount,
    this.vat,
    this.bankId,
    this.bankAccount,
    this.bankShortName,
    this.bankCode,
    this.bankName,
    this.userBankName,
    this.qrCode,
    this.totalAmount,
    this.items,
    this.fileAttachmentId,
  });

  InvoiceDetailDTO.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoiceId'];
    billNumber = json['billNumber'];
    invoiceNumber = json['invoiceNumber'];
    invoiceName = json['invoiceName'];
    timeCreated = json['timeCreated'];
    timePaid = json['timePaid'];
    status = json['status'];
    vatAmount = json['vatAmount'];
    amount = json['amount'];
    vat = json['vat'];
    bankId = json['bankId'];
    bankAccount = json['bankAccount'];
    bankShortName = json['bankShortName'];
    bankCode = json['bankCodeForPayment'];
    bankName = json['bankNameForPayment'];
    userBankName = json['userBankNameForPayment'];
    qrCode = json['qrCode'];
    totalAmount = json['totalAmount'];
    fileAttachmentId = json['fileAttachmentId'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceId'] = invoiceId;
    data['billNumber'] = billNumber;
    data['invoiceNumber'] = invoiceNumber;
    data['invoiceName'] = invoiceName;
    data['timeCreated'] = timeCreated;
    data['timePaid'] = timePaid;
    data['status'] = status;
    data['vatAmount'] = vatAmount;
    data['amount'] = amount;
    data['vat'] = vat;
    data['bankId'] = bankId;
    data['bankAccount'] = bankAccount;
    data['bankShortName'] = bankShortName;
    data['qrCode'] = qrCode;
    data['totalAmount'] = totalAmount;
    data['fileAttachmentId'] = fileAttachmentId;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? invoiceItemId;
  String? invoiceItemName;
  int? quantity;
  int? itemAmount;
  int? totalItemAmount;

  Items(
      {this.invoiceItemId,
      this.invoiceItemName,
      this.quantity,
      this.itemAmount,
      this.totalItemAmount});

  Items.fromJson(Map<String, dynamic> json) {
    invoiceItemId = json['invoiceItemId'];
    invoiceItemName = json['invoiceItemName'];
    quantity = json['quantity'];
    itemAmount = json['itemAmount'];
    totalItemAmount = json['totalItemAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invoiceItemId'] = invoiceItemId;
    data['invoiceItemName'] = invoiceItemName;
    data['quantity'] = quantity;
    data['itemAmount'] = itemAmount;
    data['totalItemAmount'] = totalItemAmount;
    return data;
  }
}
