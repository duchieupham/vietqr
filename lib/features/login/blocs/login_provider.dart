import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool isEnableButton = false;
  bool isButtonLogin = false;
  String phone = '';

  bool isQuickLogin = false;

  void updateQuickLogin(value) {
    isQuickLogin = value;
    notifyListeners();
  }

  void updateIsEnableBT(value) {
    isEnableButton = value;
    notifyListeners();
  }

  void updateBTLogin(value) {
    isButtonLogin = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    phone = value;
    if (value.isNotEmpty) {
      isEnableButton = true;
    } else {
      isEnableButton = false;
    }
    notifyListeners();
  }

  void onChangePin(String value) {
    if (value.length >= 6) {
      isButtonLogin = true;
    } else {
      isButtonLogin = false;
    }
    notifyListeners();
  }
}
