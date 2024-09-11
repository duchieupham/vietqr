import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/connect_gg_chat_provider.dart';

class SettingBDSDProvider extends ChangeNotifier {
  bool _enableVoice = false;

  // List<BankSelection> get listBank => _listBank;

  List<BankAccountDTO> _listVoiceBank = [];
  List<BankAccountDTO> get listVoiceBank => _listVoiceBank;

  bool get enableVoice => _enableVoice;

  final List<String> _bankIds = [];

  List<String> get bankIds => _bankIds;

  initData(List<BankAccountDTO> list) async {
    _enableVoice =
        _listVoiceBank.every((element) => element.enableVoice == true);

    final stringBanks = SharePrefUtils.getListEnableVoiceBank();
    if (stringBanks != null) {
      final listBanks = jsonDecode(stringBanks).split(',');
      if (listBanks.isNotEmpty) {
        _listVoiceBank = listBanks;
      }
    } else {
      _listVoiceBank = list;
    }

    notifyListeners();
  }

  List<String> getListId() {
    Set<String> bankIdSet = <String>{};
    final list =
        _listVoiceBank.where((element) => element.enableVoice == true).toList();
    for (BankAccountDTO selection in list) {
      if (selection != null) {
        bankIdSet.add(selection.id);
      }
    }

    return bankIdSet.toList(); // Convert set to list and return
  }

  void selectValue(bool value, int index) {
    _listVoiceBank.elementAt(index).enableVoice = value;
    _enableVoice =
        _listVoiceBank.every((element) => element.enableVoice == true);

    notifyListeners();
  }

  void updateOpenVoice(bool check) {
    _enableVoice = check;
    if (check) {
      for (var e in _listVoiceBank) {
        e.enableVoice = true;
      }
    } else {
      for (var e in _listVoiceBank) {
        e.enableVoice = false;
      }
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
