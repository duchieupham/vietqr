import 'package:flutter/cupertino.dart';

import '../../models/bank_account_dto.dart';

class ConnectGgChatProvider extends ChangeNotifier {
  int pageIndex = 0;
  FocusNode? focusNode = FocusNode();
  bool isAllLinked = false;
  bool isValidWebhook = false;
  bool isFilter = false;

  List<BankSelection> listBank = [];
  List<BankSelection> filterBanks = [];

  Future<void> init(List<BankAccountDTO> list) async {
    focusNode?.unfocus();
    isValidWebhook = false;
    isAllLinked = false;
    isFilter = false;
    listBank = [];
    for (var item in list) {
      listBank.add(BankSelection(bank: item, value: false));
    }
    notifyListeners();
  }

  void filterBankList(String? filter) {
    if (filter!.isNotEmpty) {
      isFilter = true;
      filterBanks = listBank
          .where((e) =>
              e.bank!.bankAccount
                  .toLowerCase()
                  .contains(filter.toLowerCase()) ||
              e.bank!.userBankName.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      isFilter = false;
    }
    notifyListeners();
  }

  List<String> getListId() {
    Set<String> bankIdSet = Set<String>();
    final list = isFilter
        ? filterBanks.where((element) => element.value == true).toList()
        : listBank.where((element) => element.value == true).toList();
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
    if (!isFilter) {
      listBank.elementAt(index).value = value;
    } else {
      filterBanks.elementAt(index).value = value;
    }

    notifyListeners();
  }

  void reset() {}
}

class BankSelection {
  BankAccountDTO? bank;
  bool? value;
  BankSelection({this.bank, this.value});
}
