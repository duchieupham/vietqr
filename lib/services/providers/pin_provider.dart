import 'package:flutter/material.dart';

class PinProvider with ChangeNotifier {
  int _pinLength = 0;

  int _pinNewPassLength = 0;

  int _pinConfirmPassLength = 0;

  get pinLength => _pinLength;
  get pinNewPassLength => _pinNewPassLength;
  get pinConfirmPassLength => _pinConfirmPassLength;

  void updatePinLength(int length) {
    _pinLength = length;
    notifyListeners();
  }

  void reset() {
    _pinLength = 0;
    notifyListeners();
  }

  void updatePinNewPassLength(int length) {
    _pinNewPassLength = length;
    notifyListeners();
  }

  void resetPinNewPass() {
    _pinNewPassLength = 0;
    notifyListeners();
  }

  void updatePinConfirmPassLength(int length) {
    _pinConfirmPassLength = length;
    notifyListeners();
  }

  void resetPinConfirmNewPass() {
    _pinConfirmPassLength = 0;
    notifyListeners();
  }
}
