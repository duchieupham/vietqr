import 'package:flutter/material.dart';

class ShareBDSDProvider with ChangeNotifier {
  int _typeList = 0;

  int get typeList => _typeList;

  int _typeFilter = 0;

  int get typeFilter => _typeFilter;

  List<String> filterTitles = ['Nhóm chia sẻ', 'Tài khoản ngân hàng'];

  String titleFilter = 'Nhóm chia sẻ';

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
