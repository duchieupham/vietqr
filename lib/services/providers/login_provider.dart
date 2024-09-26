import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class ValidProvider with ChangeNotifier {
  final dynamic _phoneKey = GlobalKey();

  get phoneKey => _phoneKey;

  void onChangePhone(String value) {
    String? msgErr = StringUtils.instance.validatePhone(value);
    _phoneKey.currentState.showError(msgErr);
    notifyListeners();
  }
}
