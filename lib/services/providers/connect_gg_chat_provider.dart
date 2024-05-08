import 'package:flutter/cupertino.dart';

import '../../models/bank_account_dto.dart';

class ConnectGgChatProvider extends ChangeNotifier {
  int pageIndex = 0;
  FocusNode? focusNode = FocusNode();
  bool isAllLinked = false;
  bool isValidWebhook = false;
  List<BankSelection> listBank = [];

  init(List<BankAccountDTO> list) {
    focusNode?.unfocus();
    isValidWebhook = false;
    isAllLinked = false;
    listBank = [];
    for (var item in list) {
      listBank.add(BankSelection(bank: item, value: false));
    }
    notifyListeners();
  }

  List<String> getListId() {
    Set<String> bankIdSet = Set<String>();
    final list = listBank.where((element) => element.value == true).toList();
    for (BankSelection selection in list) {
      if (selection.bank != null) {
        bankIdSet.add(selection.bank!.id);
      }
    }

    return bankIdSet.toList(); // Convert set to list and return
  }

  void checkValidInput(bool value) {
    isValidWebhook = value;
    notifyListeners();
  }

  void setUnFocusNode() {
    focusNode?.unfocus();
    notifyListeners();
  }

  void validateInput(String value) {
    if (value.isNotEmpty) {
      final regex = RegExp(
          r"^https://chat\.googleapis\.com/v1/spaces/[A-Za-z0-9\-]+/messages\?key=[^&]+&token=[^&]+$");
      isValidWebhook = regex.hasMatch(value);
    } else {
      isValidWebhook = true;
    }
    notifyListeners();
  }

  void changeAllValue(bool value) {
    isAllLinked = value;
    listBank.forEach((element) {
      element.value = value;
    });
    notifyListeners();
  }

  void selectValue(bool value, int index) {
    isAllLinked = false;
    listBank.elementAt(index).value = value;
    notifyListeners();
  }

  void reset() {}
}

class BankSelection {
  BankAccountDTO? bank;
  bool? value;
  BankSelection({this.bank, this.value});
}
