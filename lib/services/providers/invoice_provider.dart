import 'package:flutter/material.dart';

import '../../models/bank_account_dto.dart';

class InvoiceProvider extends ChangeNotifier {
  List<BankAccountDTO>? listBank;
  List<InvoiceStatus> status = [
    const InvoiceStatus(id: 0, name: 'Chưa thanh toán'),
    const InvoiceStatus(id: 1, name: 'Thanh toán'),
    // const InvoiceStatus(id: 2, name: ''),
  ];

  List<InvoiceTime> timeList = [
    const InvoiceTime(id: 0, name: 'Tất cả'),
    const InvoiceTime(id: 1, name: 'Tháng'),
    // const InvoiceStatus(id: 2, name: ''),
  ];

  BankAccountDTO? selectBank;

  InvoiceTime invoiceTime = const InvoiceTime(id: 0, name: 'Tất cả');

  InvoiceStatus invoiceStatus =
      const InvoiceStatus(id: 0, name: 'Chưa thanh toán');

  void selectBankAccount(BankAccountDTO bank) {
    selectBank = bank;
    notifyListeners();
  }

  void changeTime(InvoiceTime time) {
    invoiceTime = time;
    notifyListeners();
  }

  void changeStatus(InvoiceStatus type) {
    invoiceStatus = type;
    notifyListeners();
  }

  void setListBank(List<BankAccountDTO>? list) {
    listBank = list;
    notifyListeners();
  }
}

class InvoiceTime {
  final int id;
  final String name;

  const InvoiceTime({required this.id, required this.name});
}

class InvoiceStatus {
  final int id;
  final String name;

  const InvoiceStatus({required this.id, required this.name});
}
