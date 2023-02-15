import 'package:flutter/material.dart';

class SuggestionWidgetProvider with ChangeNotifier {
  //sms status:
  //0: initial
  //1: denied
  //2: allowed
  int _smsStatus = 0;
  bool _isShowUserUpdate = false;
  bool _isShowCameraPermission = false;

  get smsStatus => _smsStatus;
  get showUserUpdate => _isShowUserUpdate;
  get showCameraPermission => _isShowCameraPermission;

  void updateSMSStatus(int value) {
    _smsStatus = value;
    notifyListeners();
  }

  void updateUserUpdating(bool value) {
    _isShowUserUpdate = value;
    notifyListeners();
  }

  void updateCameraSuggestion(bool value) {
    _isShowCameraPermission = value;
    notifyListeners();
  }

  bool getSuggestion() {
    return _isShowUserUpdate || _smsStatus != 2 || _isShowCameraPermission;
  }

  void reset() {
    _smsStatus = 0;
    _isShowUserUpdate = false;
    _isShowCameraPermission = false;
  }
}
