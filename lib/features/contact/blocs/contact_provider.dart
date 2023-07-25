import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  int tab = 0;

  bool isEnableBTSave = false;

  void updateTab(value) {
    tab = value;
    notifyListeners();
  }

  void onChangeSuggest(String value) {}

  void onChangeName(String value) {
    if (value.isNotEmpty) {
      isEnableBTSave = true;
    } else {
      isEnableBTSave = false;
    }
    notifyListeners();
  }
}
