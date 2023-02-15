import 'package:flutter/cupertino.dart';

class BankAccountProvider with ChangeNotifier {
  int _indexSelected = 0;
  bool _isGetAccountBalance = false;

  get indexSelected => _indexSelected;
  get isGetAccountBalance => _isGetAccountBalance;

  void updateGetAccountBalace(bool value) {
    _isGetAccountBalance = value;
    notifyListeners();
  }

  void updateIndex(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  void reset() {
    _indexSelected = 0;
    _isGetAccountBalance = false;
  }
}
