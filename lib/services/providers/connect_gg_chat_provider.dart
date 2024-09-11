import 'package:flutter/cupertino.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';

import '../../models/bank_account_dto.dart';

class ConnectMediaProvider extends ChangeNotifier {
  int pageIndex = 0;
  FocusNode? focusNode = FocusNode();
  bool isAllLinked = false;
  bool isValidWebhook = false;
  bool isFilter = false;

  List<BankSelection> listBank = [];
  List<BankSelection> filterBanks = [];
  List<BankAccountDTO> listIsOwnerBank = [];

  Future<void> init(List<BankAccountDTO> list) async {
    focusNode?.unfocus();
    isValidWebhook = false;
    isAllLinked = false;
    isFilter = false;
    listBank = [];
    listBank = List.generate(
      list.length,
      (index) => BankSelection(bank: list[index], value: false),
    ).toList();

    notifyListeners();
  }

  void setListBank(List<BankAccountDTO> list) {
    listIsOwnerBank = list;
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
    Set<String> bankIdSet = <String>{};
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

  void validateInput(String value, TypeConnect type) {
    if (type == TypeConnect.GG_CHAT || type == TypeConnect.LARK) {
      if (value.isNotEmpty) {
        // if (type == TypeConnect.GG_CHAT) {
        //   final regex = RegExp(
        //       r"^https://chat\.googleapis\.com/v1/spaces/[A-Za-z0-9\-]+/messages\?key=[^&]+&token=[^&]+$");
        //   isValidWebhook = regex.hasMatch(value);
        // } else {
        //   String pattern = r'^(https?:\/\/)?' // Optional protocol
        //       r'((([a-zA-Z0-9$-_@.&+!*"(),]|(%[0-9a-fA-F]{2}))+\.)+[a-zA-Z]{2,})' // Domain name
        //       r'(:\d+)?(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?$'; // Port and path

        //   RegExp regExp = RegExp(pattern);
        //   isValidWebhook = regExp.hasMatch(value);
        // }
        String pattern = r'^(https?:\/\/)?' // Optional protocol
            r'((([a-zA-Z0-9$-_@.&+!*"(),]|(%[0-9a-fA-F]{2}))+\.)+[a-zA-Z]{2,})' // Domain name
            r'(:\d+)?(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?$'; // Port and path

        RegExp regExp = RegExp(pattern);
        isValidWebhook = regExp.hasMatch(value);
      } else {
        isValidWebhook = true;
      }
    } else {
      isValidWebhook = true;
    }
    notifyListeners();
  }

  void changeAllValue(bool value) {
    isAllLinked = value;
    for (var element in listBank) {
      element.value = value;
    }
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

class VoiceBank {
  BankAccountDTO? bank;
  bool? isOn;
  VoiceBank({this.bank, this.isOn});
}
