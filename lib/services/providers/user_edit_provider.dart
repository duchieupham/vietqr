import 'package:flutter/material.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class UserEditProvider with ChangeNotifier {
  bool _isAvailableUpdate = false;
  int _gender = SharePrefUtils.getProfile().gender;
  bool _isFirstNameErr = false;
  bool _isOldPassErr = false;
  bool _isNewPassErr = false;
  bool _isConfirmPassErr = false;
  bool _isEmailErr = false;

  get availableUpdate => _isAvailableUpdate;

  int get gender => _gender;

  get firstNameErr => _isFirstNameErr;

  get oldPassErr => _isOldPassErr;

  get newPassErr => _isNewPassErr;

  get confirmPassErr => _isConfirmPassErr;

  get isEmailErr => _isEmailErr;

  void setAvailableUpdate(bool value) {
    _isAvailableUpdate = value;
    notifyListeners();
  }

  void updateGender(int value) {
    _gender = value;
    notifyListeners();
  }

  void updateErrors(bool firstNameErr) {
    _isFirstNameErr = firstNameErr;
    notifyListeners();
  }

  void updatePasswordErrs(
      bool oldPassErr, bool newPassErr, bool confirmPassErr) {
    _isOldPassErr = oldPassErr;
    _isNewPassErr = newPassErr;
    _isConfirmPassErr = confirmPassErr;
    notifyListeners();
  }

  bool isValidUpdatePassword() {
    return !_isOldPassErr && !_isNewPassErr && !_isConfirmPassErr;
  }

  bool isValidUpdate() {
    return !_isFirstNameErr;
  }

  void checkValidEmail(String email) {
    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    _isEmailErr = emailRegex.hasMatch(email);
    notifyListeners();
  }

  void resetPasswordErr() {
    _isOldPassErr = false;
    _isNewPassErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }

  void reset() {
    _isAvailableUpdate = false;
    _isFirstNameErr = false;
    _isEmailErr = false;
    _gender = SharePrefUtils.getProfile().gender;
    notifyListeners();
  }
}
