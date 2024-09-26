import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class RegisterNewBankProvider with ChangeNotifier {
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
  bool _isInValidMST = false;
  bool _isInValidAddress = false;

  bool _isAgreeWithPolicy = false;
  bool _isLinkBank = false;
  String? errorTk;
  String? errorNameTK;
  String? errorCMT;
  String? errorMST;
  String? errorSDT;
  String? errorAddress;
  String bankId = '';

  get isLinkBank => _isLinkBank;

  get isAgreeWithPolicy => _isAgreeWithPolicy;

  AccountType _typeAccount = const AccountType(type: 0, tile: 'Cá nhân');
  AccountType get typeAccount => _typeAccount;

  List<AccountType> accountTypes = [
    const AccountType(type: 0, tile: 'Cá nhân'),
    const AccountType(type: 1, tile: 'Doanh nghiệp')
  ];

  void updatePolicy(value) {
    _isAgreeWithPolicy = value;
    notifyListeners();
  }

  void updateAccountType(AccountType value) {
    _typeAccount = value;
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
      errorTk = 'Số tài khoản không hợp lệ.';
    } else {
      if (text.length <= 5) {
        _isInvalidBankAccount = false;
        errorTk = 'Số tài khoản không hợp lệ.';
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
      isEnableName = true;
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
    if (typeAccount.type == 0) {
      if ((_bankTypeDTO?.bankName.isNotEmpty ?? false) &&
          _isInvalidBankAccount &&
          _isInvalidUserBankName &&
          _isInValidNationalId &&
          _isInValidAddress &&
          _isInValidPhoneAuthenticated) {
        result = true;
      }
    } else {
      if ((_bankTypeDTO?.bankCode.isNotEmpty ?? false) &&
          _isInvalidBankAccount &&
          _isInvalidUserBankName &&
          _isInValidMST &&
          _isInValidAddress &&
          _isInValidPhoneAuthenticated) {
        result = true;
      }
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
    errorMST = null;
    notifyListeners();
  }

  onChangePhone(String value, {String? cmt}) {
    if (value.isEmpty) {
      errorSDT = 'Số điện thoại xác thực không hợp lệ';
      _isInValidPhoneAuthenticated = false;
    } else {
      if (value.length < 10 || value.length > 13) {
        errorSDT = 'Số điện thoại xác thực không hợp lệ';
        _isInValidPhoneAuthenticated = false;
      } else {
        errorSDT = null;
        _isInValidPhoneAuthenticated = true;
      }
    }
    notifyListeners();
  }

  onChangeMST(String value) {
    if (value.isEmpty) {
      errorMST = 'Mã số thuế không hợp lệ';
      _isInValidMST = false;
    } else {
      errorMST = null;
      _isInValidMST = true;
    }
    notifyListeners();
  }

  onChangeAddress(String value) {
    if (value.isEmpty) {
      errorAddress = 'Địa chỉ không hợp lệ';
      _isInValidAddress = false;
    } else {
      errorMST = null;
      _isInValidAddress = true;
    }
    notifyListeners();
  }

  void onChangeCMT(String value) {
    errorCMT = null;
    if (value.isEmpty) {
      _isInValidNationalId = false;
      errorCMT = 'CCCD/CMT không hợp lệ';
    } else {
      _isInValidNationalId = true;
    }
    notifyListeners();
  }
}

class AccountType {
  final String tile;
  final int type;

  const AccountType({this.type = 0, this.tile = ''});
}
