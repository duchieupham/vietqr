import 'package:flutter/material.dart';

class SuggestionWidgetProvider with ChangeNotifier {
  bool _isShowUserUpdate = false;
  bool _isShowCameraPermission = false;

  get showUserUpdate => _isShowUserUpdate;
  get showCameraPermission => _isShowCameraPermission;

  void updateUserUpdating(bool value) {
    _isShowUserUpdate = value;
    notifyListeners();
  }

  void updateCameraSuggestion(bool value) {
    _isShowCameraPermission = value;
    notifyListeners();
  }

  bool getSuggestion() {
    return _isShowUserUpdate || _isShowCameraPermission;
  }

  void reset() {
    _isShowUserUpdate = false;
    _isShowCameraPermission = false;
  }
}
