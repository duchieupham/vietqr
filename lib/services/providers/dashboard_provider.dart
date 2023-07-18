import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  int _businessSelect = 0;
  get businessSelect => _businessSelect;
  int _businessLength = 0;
  int get businessLength => _businessLength;
  void updateBusinessSelect(int value) {
    _businessSelect = value;
    notifyListeners();
  }

  void updateBusinessLength(int value) {
    _businessLength = value;
    // notifyListeners();
  }
}
