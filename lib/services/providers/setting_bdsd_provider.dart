import 'package:flutter/material.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class SettingBDSDProvider extends ChangeNotifier {
  bool _enableVoice =
      UserHelper.instance.getAccountSetting().voiceMobile;
  bool get enableVoice => _enableVoice;

  List<String> _bankIds = [];
  List<String> get bankIds => _bankIds;
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
