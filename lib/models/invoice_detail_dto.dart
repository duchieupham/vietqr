class InvoiceDetailDTO {
  String? invoiceId;
  String? billNumber;
  String? invoiceNumber;
  String? invoiceName;
  String? timeCreated;
  String? timePaid;
  int? status;
  int? vatAmount;
  int? amount;
  int? vat;
  String? bankId;
  String? bankAccount;
  String? bankShortName;
  String? qrCode;
  int? totalAmount;
  List<Items>? items;

  InvoiceDetailDTO(
      {this.invoiceId,
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
      this.qrCode,
      this.totalAmount,
      this.items});

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
    qrCode = json['qrCode'];
    totalAmount = json['totalAmount'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceId'] = this.invoiceId;
    data['billNumber'] = this.billNumber;
    data['invoiceNumber'] = this.invoiceNumber;
    data['invoiceName'] = this.invoiceName;
    data['timeCreated'] = this.timeCreated;
    data['timePaid'] = this.timePaid;
    data['status'] = this.status;
    data['vatAmount'] = this.vatAmount;
    data['amount'] = this.amount;
    data['vat'] = this.vat;
    data['bankId'] = this.bankId;
    data['bankAccount'] = this.bankAccount;
    data['bankShortName'] = this.bankShortName;
    data['qrCode'] = this.qrCode;
    data['totalAmount'] = this.totalAmount;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoiceItemId'] = this.invoiceItemId;
    data['invoiceItemName'] = this.invoiceItemName;
    data['quantity'] = this.quantity;
    data['itemAmount'] = this.itemAmount;
    data['totalItemAmount'] = this.totalItemAmount;
    return data;
  }
}