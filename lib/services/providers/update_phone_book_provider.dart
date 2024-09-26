import 'package:flutter/material.dart';

class UpdatePhoneBookProvider extends ChangeNotifier {
  String _nickName = '';
  String get nickName => _nickName;
  String _additionalData = '';
  String get additionalData => _additionalData;

  bool _errorNickName = false;
  bool get errorNickName => _errorNickName;

  bool _errorAdditionalData = false;
  bool get errorAdditionalData => _errorAdditionalData;
  void updateNickName(String value) {
    if (value.isEmpty) {
      _errorNickName = true;
    } else {
      _errorNickName = false;
    }
    _nickName = value;
    notifyListeners();
  }

  void updateAdditionalData(String value) {
    if (value.isEmpty) {
      _errorAdditionalData = true;
    } else {
      _errorAdditionalData = false;
    }
    _additionalData = value;
    notifyListeners();
  }
}
