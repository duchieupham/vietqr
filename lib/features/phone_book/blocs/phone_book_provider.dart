import 'package:flutter/material.dart';

class PhoneBookProvider extends ChangeNotifier {
  int tab = 0;

  void updateTab(value) {
    tab = value;
    notifyListeners();
  }
}
