import 'package:flutter/cupertino.dart';

import '../../models/bank_account_dto.dart';

class ConnectGgChatProvider extends ChangeNotifier {
  int pageIndex = 0;

  bool isAllLinked = false;
  List<BankSelection> listBank = [];

  init(List<BankAccountDTO> list) {
    for (var item in list) {
      listBank.add(BankSelection(bank: item, value: false));
    }
  }

  void changeAllValue(bool value) {
    isAllLinked = value;
    listBank.forEach((element) {
      element.value = true;
    });
    notifyListeners();
  }

  void selectValue(bool value, int index) {
    isAllLinked = false;
    listBank.elementAt(index).value = value;
    notifyListeners();
  }
}

class BankSelection {
  BankAccountDTO? bank;
  bool? value;
  BankSelection({this.bank, this.value});
}
