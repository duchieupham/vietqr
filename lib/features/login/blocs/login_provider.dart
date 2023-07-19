import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class LoginProvider with ChangeNotifier {
  bool isEnableButton = false;
  bool isButtonLogin = false;
  String phone = '';
  String? errorPhone;

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

    if (phone.length == 9) {
      if (phone[0] != '0') {
        phone = '0$phone';
      }
    }
    errorPhone = StringUtils.instance.validatePhone(phone);
    if (errorPhone != null || value.isEmpty) {
      isEnableButton = false;
    } else {
      isEnableButton = true;
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
