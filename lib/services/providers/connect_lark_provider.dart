import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectLarkProvider extends ChangeNotifier {
  bool _chooseAllBank = false;

  bool get chooseAllBank => _chooseAllBank;
  final List<String> _titles = [
    'Chọn ngân hàng',
    'Tạo Lark Webhook',
    'Thiết lập Lark'
  ];

  List<String> get titles => _titles;
  int _curStep = 1;

  int get curStep => _curStep;

  final List<String> _bankIds = [];

  List<String> get bankIds => _bankIds;

  String _webHook = '';

  String get webHook => _webHook;

  bool _errorWebhook = false;

  bool get errorWebhook => _errorWebhook;
  String _clipboardText = '';

  String get clipboardText => _clipboardText;

  addAll(String bankId) {
    _chooseAllBank = true;
    if (!_bankIds.contains(bankId)) {
      _bankIds.add(bankId);
    }
  }

  void updateWebHook(String value) {
    _webHook = value.trim();
    if (_webHook.isEmpty ||
        !(_webHook.contains('https://') || _webHook.contains('http://'))) {
      _errorWebhook = true;
    } else {
      _errorWebhook = false;
    }
    notifyListeners();
  }

  checkWebHookExist() {
    if (_webHook.isEmpty) {
      _errorWebhook = true;
    } else {
      _errorWebhook = false;
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
      if (textCopied.contains('http://') || textCopied.contains('https://')) {
        _clipboardText = textCopied;
        notifyListeners();
      }
    }
  }

  clearClipBoardData() {
    _clipboardText = '';
  }
}
