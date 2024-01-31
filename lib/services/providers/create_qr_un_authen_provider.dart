import 'package:flutter/widgets.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class CreateQrUnATProvider with ChangeNotifier {
  String _money = '';
  bool _showMoreOption = false;

  bool get showMoreOption => _showMoreOption;

  String get money => _money;

  void updateMoney(String value) {
    int data = int.parse(value.replaceAll('.', ''));
    _money = StringUtils.formatNumber(data);
    notifyListeners();
  }

  BankTypeDTO _bankType = BankTypeDTO();

  bool _isNameErr = false;
  bool _isBankAccountErr = false;
  bool _isNationalErr = false;
  bool _isPhoneErr = false;
  bool _isAgreeWithPolicy = false;
  bool _isShowBankAccount = true;
  bool _isAmountErr = false;
  bool _isValidCreate = true;

  BankTypeDTO get bankType => _bankType;

  bool get nameErr => _isNameErr;

  bool get bankAccountErr => _isBankAccountErr;

  bool get nationalErr => _isNationalErr;

  bool get phoneErr => _isPhoneErr;

  bool get agreeWithPolicy => _isAgreeWithPolicy;

  bool get showBankAccount => _isShowBankAccount;

  bool get isAmountErr => _isAmountErr;

  bool get isValidCreate => _isValidCreate;

  void updateShowBankAccount(bool value) {
    _isShowBankAccount = value;
    notifyListeners();
  }

  void updateValidCreate(bool value) {
    _isValidCreate = value;

    notifyListeners();
  }

  void updateAgreePolicy(bool value) {
    _isAgreeWithPolicy = value;
    notifyListeners();
  }

  bool isValidUnauthenticateForm() {
    return (_bankType.bankCode.isNotEmpty && !_isNameErr && !_isBankAccountErr);
  }

  updateShowMoreOption(bool errorAmount) {
    _showMoreOption = !_showMoreOption;
    _isValidCreate = errorAmount;
    notifyListeners();
  }

  bool isValidAuthenticateForm() {
    return (_bankType.id.isNotEmpty &&
        !_isNameErr &&
        !_isBankAccountErr &&
        !_isNationalErr &&
        !_isPhoneErr);
  }

  void updateBankType(BankTypeDTO value) {
    _bankType = value;
    notifyListeners();
  }

  void updateNameErr(bool value) {
    _isNameErr = value;
    notifyListeners();
  }

  void updateBankAccountErr(bool value) {
    _isBankAccountErr = value;
    notifyListeners();
  }

  void updateAmountErr(bool value) {
    _isAmountErr = value;
    notifyListeners();
  }

  void updateNationalErr(bool value) {
    _isNationalErr = value;
    notifyListeners();
  }

  void updatePhoneErr(bool value) {
    _isPhoneErr = value;
    notifyListeners();
  }

  void reset() {
    _bankType = BankTypeDTO();
    _isNameErr = false;
    _isBankAccountErr = false;
    _isNationalErr = false;
    _isPhoneErr = false;
    _isAgreeWithPolicy = false;
  }

  void resetValidate() {
    _isNameErr = false;
    _isBankAccountErr = false;
    _isNationalErr = false;
    _isPhoneErr = false;
    _isAgreeWithPolicy = false;
    notifyListeners();
  }
}
