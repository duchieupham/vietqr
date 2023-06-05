import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class RegisterProvider with ChangeNotifier {
  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;
  bool _isConfirmPassErr = false;

  get phoneErr => _isPhoneErr;

  get passwordErr => _isPasswordErr;

  get confirmPassErr => _isConfirmPassErr;

  final dynamic _phoneKey = GlobalKey();
  final dynamic _passKey = GlobalKey();
  final dynamic _rePassKey = GlobalKey();

  get phoneKey => _phoneKey;

  get passKey => _passKey;

  get rePassKey => _rePassKey;

  void onChangePhone(String value) {
    String? msgErr = StringUtils.instance.validatePhone(value);
    _phoneKey.currentState.showError(msgErr);
    notifyListeners();
  }

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
