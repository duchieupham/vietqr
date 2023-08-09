import 'package:flutter/material.dart';

class ConnectTelegramProvider extends ChangeNotifier {
  bool _chooseAllBank = false;
  bool get chooseAllBank => _chooseAllBank;
  List<String> _titles = [
    'Chọn ngân hàng',
    'Thêm VietQR Bot',
    'Thiết lập Telegram'
  ];
  List<String> get titles => _titles;
  int _curStep = 1;
  int get curStep => _curStep;

  List<String> _bankIds = [];
  List<String> get bankIds => _bankIds;

  String _chatId = '';
  String get chatId => _chatId;
  bool _errChatId = false;
  bool get errChatId => _errChatId;
  void updateChatId(String value) {
    _chatId = value;
    if (_chatId.isEmpty || _chatId[0] != '-') {
      _errChatId = true;
    } else {
      _errChatId = false;
    }
    notifyListeners();
  }

  void updateStep(int value) {
    _curStep = value;
    notifyListeners();
  }

  void updateChooseAllBank(bool value) {
    _chooseAllBank = value;
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

  void addAllListBank(String bankId) {
    if (!_bankIds.contains(bankId)) {
      _bankIds.add(bankId);
    }
    print('--------------------------$bankIds');
    notifyListeners();
  }
}
