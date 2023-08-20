import 'package:flutter/material.dart';

class BankCardSelectProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int _totalBanks = 0;

  int get selectedIndex => _selectedIndex;

  int get totalBanks => _totalBanks;

  void updateTotalBanks(int value) {
    _totalBanks = value;
    notifyListeners();
  }

  void updateSelectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  void reset() {
    _selectedIndex = 0;
    _totalBanks = 0;
  }
}
