import 'package:flutter/material.dart';

class PinProvider with ChangeNotifier {
  int _pinLength = 0;

  get pinLength => _pinLength;

  void updatePinLength(int length) {
    _pinLength = length;
    notifyListeners();
  }

  void reset() {
    _pinLength = 0;
    notifyListeners();
  }
}
