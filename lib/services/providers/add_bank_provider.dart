import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/branch_choice_dto.dart';

class AddBankProvider with ChangeNotifier {
  bool _isGetBankTypes = false;
  int _index = 0;
  //type = 0 => personal bank card
  //type = 1 => business bank card
  int _type = 0;
  String _branchId = '';
  BankTypeDTO _bankTypeDTO = const BankTypeDTO(
      id: '', bankCode: '', bankName: '', imageId: '', status: 0);

  BranchChoiceInsertDTO _branchChoiceInsertDTO = const BranchChoiceInsertDTO(
    companyName: '',
    image: '',
    coverImage: '',
    branchName: '',
    branchAddress: '',
    branchId: '',
  );

  bool _isInvalidBankAccount = false;
  bool _isInvalidUserBankName = false;

  get getBankTypes => _isGetBankTypes;
  get index => _index;
  get type => _type;
  get bankTypeDTO => _bankTypeDTO;
  get validBankAccount => _isInvalidBankAccount;
  get validUserBankName => _isInvalidUserBankName;
  get branchId => _branchId;
  get branchChoiceInsertDTO => _branchChoiceInsertDTO;

  void updateBranchChoice(BranchChoiceInsertDTO dto) {
    _branchChoiceInsertDTO = dto;
    notifyListeners();
  }

  void updateSelectBankType(BankTypeDTO dto) {
    _bankTypeDTO = dto;
    notifyListeners();
  }

  void updateIndex(int value) {
    _index = value;
    notifyListeners();
  }

  void updateType(int value) {
    _type = value;
    notifyListeners();
  }

  void updateBranchId(String value) {
    _branchId = value;
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
    _branchId = '';
    _index = 0;
    _type = 0;
    _isInvalidBankAccount = false;
    _isInvalidUserBankName = false;
    _bankTypeDTO = const BankTypeDTO(
        id: '', bankCode: '', bankName: '', imageId: '', status: 0);
    _branchChoiceInsertDTO = const BranchChoiceInsertDTO(
      companyName: '',
      image: '',
      coverImage: '',
      branchName: '',
      branchAddress: '',
      branchId: '',
    );
  }
}
