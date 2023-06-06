import 'package:flutter/material.dart';
import 'package:vierqr/models/business_member_dto.dart';

class SearchClearProvider extends ValueNotifier {
  SearchClearProvider(super.value);

  void updateClearSearch(bool check) {
    value = check;
  }
}

class SearchProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int _existed = 0;

  int get existed => _existed;

  BusinessMemberDTO _dto = const BusinessMemberDTO(
    userId: '',
    status: '',
    existed: 0,
    imgId: '',
    name: '',
    phoneNo: '',
    role: 0,
  );

  BusinessMemberDTO get dto => _dto;

  void updateLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateDTO(value) {
    _dto = value;
    notifyListeners();
  }

  void updateExisted(value) {
    _existed = value;
    notifyListeners();
  }
}
