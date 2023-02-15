import 'package:flutter/material.dart';

class HomeTabProvider with ChangeNotifier {
  bool _isExpanded = false;
  int _tabSelect = 0;

  get isExpanded => _isExpanded;
  get tabSelect => _tabSelect;

  void updateExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  void updateTabSelect(int value) {
    _tabSelect = value;
    notifyListeners();
  }
}
