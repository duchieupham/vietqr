import 'package:flutter/material.dart';

class ShareBDSDProvider with ChangeNotifier {
  int _typeList = 0;

  int get typeList => _typeList;

  int _typeFilter = 0;

  int get typeFilter => _typeFilter;

  List<String> filterTitles = ['Cửa hàng', 'Tài khoản ngân hàng'];

  String titleFilter = 'Cửa hàng';

  int offset = 0;

  void updateOffset(int value) {
    offset = value;
    notifyListeners();
  }

  void updateTypeFilter(String value) {
    titleFilter = value;
    _typeFilter = filterTitles.indexOf(value);
    notifyListeners();
  }

  void updateTypeList(int value) {
    _typeList = value;
    notifyListeners();
  }

  int getTypeFilter() {
    if (_typeList == 0 && _typeFilter == 0) {
      return 0;
    } else if (_typeList == 0 && _typeFilter == 1) {
      return 1;
    } else if (_typeList == 1 && _typeFilter == 0) {
      return 2;
    } else {
      return 3;
    }
  }
}
