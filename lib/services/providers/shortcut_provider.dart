import 'package:flutter/material.dart';

class ShortcutProvider with ChangeNotifier {
  bool _isEnableShortcut = true;
  bool _isExpanded = true;

  get enableShortcut => _isEnableShortcut;
  get expanded => _isExpanded;

  void updateEnableShortcut(bool value) {
    _isEnableShortcut = value;
    notifyListeners();
  }

  void updateExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }
}
