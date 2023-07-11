import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/branch_choice_dto.dart';

class AddBankProvider with ChangeNotifier {
  String _bankId = '';
  bool _isGetBankTypes = false;
  int _index = 0;

  //type = 0 => personal bank card
  //type = 1 => business bank card
  int _type = 0;

  //
  int _select = 0;

  bool _enableNameTK = false;

  String _branchId = '';
  BankTypeDTO _bankTypeDTO = const BankTypeDTO(
    id: '',
    bankCode: '',
    bankName: '',
    imageId: '',
    status: 0,
    caiValue: '',
  );

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
  bool _isInValidNationalId = false;
  bool _isInValidPhoneAuthenticated = false;
  bool _isAgreeWithPolicy = false;
  bool _isRegisterAuthentication = false;
  String? errorTk;
  String? errorNameTK;
  String? errorCMT;
  String? errorSDT;

  get getBankTypes => _isGetBankTypes;

  get index => _index;

  get type => _type;

  BankTypeDTO get bankTypeDTO => _bankTypeDTO;

  get validBankAccount => _isInvalidBankAccount;

  get validUserBankName => _isInvalidUserBankName;

  get validNationalId => _isInValidNationalId;

  get validPhoneAuthenticated => _isInValidPhoneAuthenticated;

  get branchId => _branchId;

  get branchChoiceInsertDTO => _branchChoiceInsertDTO;

  get isAgreeWithPolicy => _isAgreeWithPolicy;

  get registerAuthentication => _isRegisterAuthentication;

  get select => _select;

  get bankId => _bankId;

  get enableNameTK => _enableNameTK;

  void updateBankId(String value) {
    _bankId = value;
    notifyListeners();
  }

  void updateSelect(int value) {
    _select = value;
    notifyListeners();
  }

  void updateAgreeWithPolicy(bool value) {
    _isAgreeWithPolicy = value;
    notifyListeners();
  }

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

  void updateValidBankAccount(String text) {
    errorTk = null;
    if (text.isEmpty) {
      _isInvalidBankAccount = false;
      errorTk = 'Số thẻ/tài khoản không hợp lệ.';
    } else {
      if (text.length <= 5) {
        _isInvalidBankAccount = false;
        errorTk = 'Số thẻ/tài khoản không hợp lệ.';
      } else {
        _isInvalidBankAccount = true;
      }
    }
    notifyListeners();
  }

  void updateValidUserBankName(bool value) {
    errorNameTK = null;
    if (!value) {
      errorNameTK = 'Chủ thẻ/tài khoản không hợp lệ';
    }
    _isInvalidUserBankName = value;
    notifyListeners();
  }

  void updateValidNationalId(bool value) {
    errorCMT = null;
    if (!value) {
      errorCMT = 'CCCD/CMT không hợp lệ';
    }
    _isInValidNationalId = value;
    notifyListeners();
  }

  void updateValidPhoneAuthenticated(bool value) {
    errorSDT = null;
    if (!value) {
      errorSDT = 'Số điện thoại xác thực không hợp lệ';
    }
    _isInValidPhoneAuthenticated = value;
    notifyListeners();
  }

  void updateRegisterAuthentication(bool value) {
    _isRegisterAuthentication = value;
    notifyListeners();
  }

  bool isValidForm() {
    print("errorNameTK : $errorNameTK - $_isInvalidUserBankName");
    print("errorSDT : $errorSDT - $_isInValidPhoneAuthenticated");
    print("errorCMT : $errorCMT - $_isInValidNationalId");
    print("errorTk : $errorTk - $_isInvalidBankAccount");
    bool result = false;
    if (_isInvalidBankAccount &&
        _isInvalidUserBankName &&
        _isInValidNationalId &&
        _isInValidPhoneAuthenticated) {
      result = true;
    }
    return result;
  }

  bool isValidFormUnauthentication() {
    bool result = false;
    if (_isInvalidBankAccount && _isInvalidUserBankName) {
      result = true;
    }
    return result;
  }

  setEnableNameTK(bool value) {
    _enableNameTK = value;
    notifyListeners();
  }

  void resetValidate() {
    _isInvalidBankAccount = false;
    _isInvalidUserBankName = false;
    _isInValidNationalId = false;
    _isInValidPhoneAuthenticated = false;
    errorNameTK = null;
    errorTk = null;
    errorCMT = null;
    errorSDT = null;
    notifyListeners();
  }

  void reset() {
    _bankId = '';
    _select = 0;
    _isGetBankTypes = false;
    _branchId = '';
    _index = 0;
    _type = 0;
    _enableNameTK = false;
    _isInvalidBankAccount = false;
    _isInvalidUserBankName = false;
    _isInValidNationalId = false;
    _isInValidPhoneAuthenticated = false;
    _isRegisterAuthentication = false;
    _isAgreeWithPolicy = false;
    errorNameTK = null;
    errorTk = null;

    _branchChoiceInsertDTO = const BranchChoiceInsertDTO(
      companyName: '',
      image: '',
      coverImage: '',
      branchName: '',
      branchAddress: '',
      branchId: '',
    );

    notifyListeners();
  }
}
