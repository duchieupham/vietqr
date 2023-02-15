import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class AddBankProvider with ChangeNotifier {
  bool _isGetBankTypes = false;
  int _index = 0;
  BankTypeDTO _bankTypeDTO = const BankTypeDTO(
      id: '', bankCode: '', bankName: '', imageId: '', status: 0);

  bool _isInvalidBankAccount = false;
  bool _isInvalidUserBankName = false;

  get getBankTypes => _isGetBankTypes;
  get index => _index;
  get bankTypeDTO => _bankTypeDTO;
  get validBankAccount => _isInvalidBankAccount;
  get validUserBankName => _isInvalidUserBankName;

  void updateSelectBankType(BankTypeDTO dto) {
    _bankTypeDTO = dto;
    notifyListeners();
  }

  void updateIndex(int value) {
    _index = value;
    notifyListeners();
  }

  void updateGetBankType(bool value) {
    _isGetBankTypes = value;
    notifyListeners();
  }

  void updateValidBankAccount(bool value) {
    _isInvalidBankAccount = value;
    notifyListeners();
  }

  void updateValidUserBankName(bool value) {
    _isInvalidUserBankName = value;
    notifyListeners();
  }

  void reset() {
    _isGetBankTypes = false;
    _index = 0;
    _isInvalidBankAccount = false;
    _isInvalidUserBankName = false;
    _bankTypeDTO = const BankTypeDTO(
        id: '', bankCode: '', bankName: '', imageId: '', status: 0);
  }
}
