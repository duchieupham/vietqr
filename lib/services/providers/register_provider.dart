import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;
  bool _isConfirmPassErr = false;

  get phoneErr => _isPhoneErr;
  get passwordErr => _isPasswordErr;
  get confirmPassErr => _isConfirmPassErr;

  void updateErrs({
    required bool phoneErr,
    required bool passErr,
    required bool confirmPassErr,
  }) {
    _isPhoneErr = phoneErr;
    _isPasswordErr = passErr;
    _isConfirmPassErr = confirmPassErr;

    notifyListeners();
  }

  bool isValidValidation() {
    return !_isPhoneErr && !_isPasswordErr && !_isConfirmPassErr;
  }

  void reset() {
    _isPhoneErr = false;
    _isPasswordErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }
}
