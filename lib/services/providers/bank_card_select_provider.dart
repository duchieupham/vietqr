import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class BankCardSelectProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int _totalBanks = 0;
  List<BankAccountDTO> _banks = [];
  List<Color> _colors = [];
  List<BankAccountDTO> _searchBanks = [];
  List<Color> _searchColors = [];

  int get selectedIndex => _selectedIndex;
  int get totalBanks => _totalBanks;
  List<BankAccountDTO> get banks => _banks;
  List<BankAccountDTO> get searchBanks => _searchBanks;
  List<Color> get colors => _colors;
  List<Color> get searchColors => _searchColors;

  void updateColors(List<Color> value) {
    _colors = value;
    notifyListeners();
  }

  void updateSearchColors(List<Color> value) {
    _searchColors = value;
    notifyListeners();
  }

  void updateSearchBanks(List<BankAccountDTO> value) {
    _searchBanks = value;
    notifyListeners();
  }

  void updateBanks(List<BankAccountDTO> value) {
    _banks = value;
    notifyListeners();
  }

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
    _banks = [];
    _searchBanks = [];
    _colors = [];
    _searchColors = [];
  }
}
