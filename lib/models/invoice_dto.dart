// To parse this JSON data, do
//
//     final invoiceDto = invoiceDtoFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

List<InvoiceDTO> invoiceDtoFromJson(String str) =>
    List<InvoiceDTO>.from(json.decode(str).map((x) => InvoiceDTO.fromJson(x)));

String invoiceDtoToJson(List<InvoiceDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InvoiceDTO {
  final int? amount;
  final String? billId;
  final int? timeCreated;
  final int? timePaid;
  final int? status;
  final String? name;
  final int? type;
  final List<Item>? items;

  String get getTimeCreate => (timeCreated != null)
      ? DateFormat('HH:mm dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(timeCreated! * 1000))
      : '0';

  String get getStatus => status == 1 ? 'Đã thanh toán' : 'Chưa thanh toán';

  InvoiceDTO({
    this.amount,
    this.billId,
    this.timeCreated,
    this.timePaid,
    this.status,
    this.name,
    this.type,
    this.items,
  });

  factory InvoiceDTO.fromJson(Map<String, dynamic> json) => InvoiceDTO(
        amount: json["amount"],
        billId: json["billId"],
        timeCreated: json["timeCreated"],
        timePaid: json["timePaid"],
        status: json["status"],
        name: json["name"],
        type: json["type"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "billId": billId,
        "timeCreated": timeCreated,
        "timePaid": timePaid,
        "status": status,
        "name": name,
        "type": type,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  final String? id;
  final int? amount;
  final String? billId;
  final String? description;
  final String? name;
  final int? quantity;
  final int? totalAmount;

  Item({
    this.id,
    this.amount,
    this.billId,
    this.description,
    this.name,
    this.quantity,
    this.totalAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        amount: json["amount"],
        billId: json["billId"],
        description: json["description"],
        name: json["name"],
        quantity: json["quantity"],
        totalAmount: json["totalAmount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "billId": billId,
        "description": description,
        "name": name,
        "quantity": quantity,
        "totalAmount": totalAmount,
      };
}
