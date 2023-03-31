import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/log.dart';

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
    LOG.info('=====updateCameraSuggestion: $value');
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
