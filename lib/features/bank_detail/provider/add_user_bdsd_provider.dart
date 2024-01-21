import 'package:flutter/material.dart';

class AddUserBDSDProvider with ChangeNotifier {
  int _typeSearch = 0;

  int get typeSearch => _typeSearch;

  void changeTypeSearch(int value) {
    _typeSearch = value;
    notifyListeners();
  }
}
