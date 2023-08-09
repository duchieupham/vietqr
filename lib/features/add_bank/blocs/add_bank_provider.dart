import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class AddBankProvider with ChangeNotifier {
  BankTypeDTO? _bankTypeDTO;

  BankTypeDTO? get bankTypeDTO => _bankTypeDTO;

  final keyAccount = GlobalKey();

  bool isEnableName = false;
  bool isEnableButton = false;
  bool isEnableBTLK = false;

  //
  int step = 0;

  //type = 0 => personal bank card
  //type = 1 => business bank card
  int _type = 0;

  get type => _type;

  bool isEdit = true;

  bool _isInvalidBankAccount = false;
  bool _isInvalidUserBankName = false;
  bool _isInValidNationalId = false;
  bool _isInValidPhoneAuthenticated = false;
  bool _isAgreeWithPolicy = false;
  bool _isLinkBank = false;
  String? errorTk;
  String? errorNameTK;
  String? errorCMT;
  String? errorSDT;

  String bankId = '';

  get isLinkBank => _isLinkBank;

  get isAgreeWithPolicy => _isAgreeWithPolicy;

  void updatePolicy(value) {
    _isAgreeWithPolicy = value;
    notifyListeners();
  }

  void updateEdit(value) {
    isEdit = value;
    notifyListeners();
  }

  void updateBankId(value) {
    bankId = value;
    notifyListeners();
  }

  void updateStep(value) {
    step = value;
    if (value == 0) {
    } else if (value == 1) {
      errorCMT = null;
      errorSDT = null;
    } else {}
    notifyListeners();
  }

  void updateType(int value) {
    _type = value;
    notifyListeners();
  }

  void updateSelectBankType(BankTypeDTO dto, {bool update = false}) {
    _bankTypeDTO = dto;
    isEnableName = false;
    isEnableButton = false;
    if (update) {
      _isInvalidBankAccount = update;
      _isInvalidUserBankName = update;
    }
    notifyListeners();
  }

  void updateEnableName(value) {
    isEnableName = value;
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
        isEdit = true;
        _isInvalidBankAccount = true;
      }
    }
    notifyListeners();
  }

  void updateValidUserBankName(String value) {
    errorNameTK = null;
    if (value.isEmpty) {
      errorNameTK = 'Chủ thẻ/tài khoản không hợp lệ';
      _isInvalidUserBankName = false;
      isEnableButton = false;
    } else {
      _isInvalidUserBankName = true;
      isEnableButton = true;
    }

    notifyListeners();
  }

  void updateLinkBank(bool value) {
    _isLinkBank = value;
    notifyListeners();
  }

  bool isValidForm() {
    bool result = false;
    if (_isInvalidBankAccount &&
        _isInvalidUserBankName &&
        _isInValidNationalId &&
        _isInValidPhoneAuthenticated) {
      result = true;
    }
    return result;
  }

  bool isValidFormUnAuthentication() {
    bool result = false;
    if (_isInvalidBankAccount && _isInvalidUserBankName) {
      result = true;
    }
    return result;
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

  onChangePhone(String value, {String? cmt}) {
    errorSDT = null;
    if (value.isEmpty) {
      errorSDT = 'Số điện thoại xác thực không hợp lệ';
      _isInValidPhoneAuthenticated = false;
    } else {
      if (cmt != null && cmt.isNotEmpty) {
        _isInValidNationalId = true;
      }
      _isInValidPhoneAuthenticated = true;
    }
    notifyListeners();
  }

  void onChangeCMT(String value, {String? phone}) {
    errorCMT = null;
    if (value.isEmpty) {
      errorCMT = 'CCCD/CMT không hợp lệ';
      _isInValidNationalId = false;
    } else {
      if (phone != null && phone.isNotEmpty) {
        _isInValidPhoneAuthenticated = true;
      }
      _isInValidNationalId = true;
    }
    notifyListeners();
  }
}
