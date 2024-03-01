import 'package:flutter/material.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class SettingBDSDProvider extends ChangeNotifier {
  bool _enableVoice = false;

  bool get enableVoice => _enableVoice;

  List<String> _bankIds = [];

  List<String> get bankIds => _bankIds;

  initData() async {
    SettingAccountDTO settingAccountDTO =
        await SharePrefUtils.getAccountSetting();
    _enableVoice = settingAccountDTO.voiceMobile;
    notifyListeners();
  }

  void updateOpenVoice(bool check) {
    _enableVoice = check;
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
