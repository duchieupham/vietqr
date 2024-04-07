import 'package:flutter/material.dart';

class MaintainChargeProvider extends ChangeNotifier {
  bool _isError = false;
  String _bankAccount = '';
  String _bankName = '';

  get isError => _isError;
  get bankAccount => _bankAccount;
  get bankName => _bankName;

  void selectedBank(String acc, String name) {
    _bankAccount = acc;
    _bankName = name;
  }

  void setIsError(bool isError) {
    _isError = isError;
    notifyListeners();
  }

  void resetBank() {
    _bankAccount = '';
    _bankName = '';
    notifyListeners();
  }
}
