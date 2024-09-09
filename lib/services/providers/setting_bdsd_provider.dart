import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/connect_gg_chat_provider.dart';

class SettingBDSDProvider extends ChangeNotifier {
  bool _enableVoice = false;

  List<BankSelection> _listBank = [];
  List<BankSelection> get listBank => _listBank;

  bool get enableVoice => _enableVoice;

  final List<String> _bankIds = [];

  List<String> get bankIds => _bankIds;

  initData(List<BankAccountDTO> list) async {
    SettingAccountDTO settingAccountDTO = SharePrefUtils.getAccountSetting();
    _enableVoice = settingAccountDTO.voiceMobile;
    _listBank = List.generate(
      list.length,
      (index) => BankSelection(
          bank: list[index], value: settingAccountDTO.voiceMobile),
    ).toList();

    notifyListeners();
  }

  List<String> getListId() {
    Set<String> bankIdSet = <String>{};
    final list = _listBank.where((element) => element.value == true).toList();
    for (BankSelection selection in list) {
      if (selection.bank != null) {
        bankIdSet.add(selection.bank!.id);
      }
    }

    return bankIdSet.toList(); // Convert set to list and return
  }

  void selectValue(bool value, int index) {
    _listBank.elementAt(index).value = value;
    _enableVoice = _listBank.every((element) => element.value == true);

    notifyListeners();
  }

  void updateOpenVoice(bool check) {
    _enableVoice = check;
    if (check) {
      _listBank = List.generate(
        _listBank.length,
        (index) => BankSelection(bank: _listBank[index].bank, value: true),
      ).toList();
    }
    notifyListeners();
  }

  void updateListBank(String bankId) {
    if (_bankIds.contains(bankId)) {
      _bankIds.remove(bankId);
    } else {
      _bankIds.add(bankId);
    }
    print('--------------------------$bankIds');
    notifyListeners();
  }
}
