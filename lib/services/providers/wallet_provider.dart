import 'package:flutter/material.dart';

class WalletProvider extends ChangeNotifier {
  bool _isHide = false;

  bool get isHide => _isHide;

  void updateHideAmount(bool check) {
    _isHide = check;
    notifyListeners();
  }
}
