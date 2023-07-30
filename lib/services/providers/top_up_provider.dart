import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class TopUpProvider extends ChangeNotifier {
  String _money = StringUtils.formatNumber(50000);

  String get money => _money;

  String _errorMoney = '';

  String get errorMoney => _errorMoney;

  void updateMoney(String value) {
    if (value.isEmpty) {
      _errorMoney = 'Số tiền không được để trống';
    } else {
      _errorMoney = '';
    }
    int data = int.parse(value.replaceAll('.', ''));
    if (data < 10000) {
      _errorMoney = 'Số tiền phải lớn hơn 10.000';
    }
    _money = StringUtils.formatNumber(data);
    notifyListeners();
  }
}
