import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectTelegramProvider extends ChangeNotifier {
  bool _chooseAllBank = false;
  bool get chooseAllBank => _chooseAllBank;
  final List<String> _titles = const [
    'Chọn ngân hàng',
    'Thêm VietQR Bot',
    'Thiết lập Telegram'
  ];
  List<String> get titles => _titles;
  int _curStep = 1;
  int get curStep => _curStep;

  final List<String> _bankIds = [];
  List<String> get bankIds => _bankIds;

  String _chatId = '';
  String get chatId => _chatId;
  bool _errChatId = false;
  bool get errChatId => _errChatId;
  String _clipboardText = '';
  String get clipboardText => _clipboardText;

  addAll(String bankId) {
    _chooseAllBank = true;
    if (!_bankIds.contains(bankId)) {
      _bankIds.add(bankId);
    }
  }

  void updateChatId(String value) {
    _chatId = value;
    if (_chatId.isEmpty || double.tryParse(_chatId) == null) {
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

  void getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data?.text?.isNotEmpty ?? false) {
      String textCopied = data?.text! ?? '';
      if (double.tryParse(textCopied) != null && textCopied.length > 6) {
        _clipboardText = textCopied;
        notifyListeners();
      }
    }
  }

  clearClipBoardData() {
    _clipboardText = '';
  }
}
