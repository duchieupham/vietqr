import 'package:vierqr/commons/utils/bank_information_utils.dart';
import 'package:flutter/cupertino.dart';

class BankSelectProvider with ChangeNotifier {
  //
  String _bankSelected = 'Chọn ngân hàng';

  //error handler
  bool _isBankSelectErr = false;
  bool _isBankAccountErr = false;
  bool _isBankAccountNameErr = false;

  get bankSelected => _bankSelected;
  get bankSelectErr => _isBankSelectErr;
  get bankAccountErr => _isBankAccountErr;
  get bankAccountNameErr => _isBankAccountNameErr;

  void updateBankSelected(String value) {
    _bankSelected = value;
    notifyListeners();
  }

  void updateErrs(
      bool bankSelectErr, bool bankAccountErr, bool bankAccountNameErr) {
    _isBankSelectErr = bankSelectErr;
    _isBankAccountErr = bankAccountErr;
    _isBankAccountNameErr = bankAccountNameErr;
    notifyListeners();
  }

  List<String> getListAvailableBank() {
    List<String> result = [];
    _bankSelected = 'Chọn ngân hàng';
    result.add(_bankSelected);
    result.addAll(BankInformationUtil.instance.getAvailableAddingBanks());
    return result;
  }
}
