import 'package:flutter/material.dart';
import 'package:vierqr/models/user_bank_dto.dart';

class MemeberManageProvider with ChangeNotifier {
  bool _isAvailableRefresh = true;
  bool _isTextError = false;
  final List<UserBankDTO> _users = [];

  get availableRefresh => _isAvailableRefresh;
  get textError => _isTextError;
  get users => _users;

  void setAvailableUpdate(bool value) {
    _isAvailableRefresh = value;
    notifyListeners();
  }

  void setUsers(List<UserBankDTO> value) {
    _users.clear();
    _users.addAll(value);
    notifyListeners();
  }

  void updateErr(bool isTextErr) {
    _isTextError = isTextErr;
    notifyListeners();
  }

  void reset() {
    _isAvailableRefresh = true;
    _isTextError = false;
    _users.clear();
  }
}
