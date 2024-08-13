import 'package:flutter/material.dart';

import '../../../models/bank_type_dto.dart';

class CustomerVaInsertProvider with ChangeNotifier {


  final keyAccount = GlobalKey();
  final String _bidvLogoUrl = 'https://dev.vietqr.org/vqr/images/bidv.png';
  bool _isMerchantNameErr = false;
  bool _isBankAccountErr = false;
  bool _isUserBankNameErr = false;
  bool _isNationalIdErr = false;
  bool _isPhoneAuthenticatedErr = false;

  bool _isAgreePolicy = false;

  bool isEdit = true;
  bool isEnableName = false;

  String _merchantName = '';
  String _bankAccount = '';
  String _userBankName = '';
  String _nationalId = '';
  String _phoneAuthenticated = '';
  String _otp = '';

  String _merchantId = '';
  String _confirmId = '';

  get bidvLogoUrl => _bidvLogoUrl;
  get merchantName => _merchantName;
  get merchantNameErr => _isMerchantNameErr;
  get bankAccount => _bankAccount;
  get bankAccountErr => _isBankAccountErr;
  get userBankName => _userBankName;
  get userBankNameErr => _isUserBankNameErr;
  get nationalId => _nationalId;
  get nationalIdErr => _isNationalIdErr;
  get phoneAuthenticated => _phoneAuthenticated;
  get phoneAuthenticatedErr => _isPhoneAuthenticatedErr;
  get aggreePolicy => _isAgreePolicy;
  get otp => _otp;
  get merchantId => _merchantId;
  get confirmId => _confirmId;

  void updateMerchantIdAndConfirmId(String value1, String value2) {
    _merchantId = value1;
    _confirmId = value2;
    notifyListeners();
  }

  void updateOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  void updateAgreePolicy(value) {
    _isAgreePolicy = value;
    notifyListeners();
  }

  void updateBankAccount(String value) {
    _bankAccount = value;
    if (!_checkValidBankAccount(value)) {
      _isBankAccountErr = true;
    } else {
      _isBankAccountErr = false;
    }
    notifyListeners();
  }

  void updateEnableName(value) {
    isEnableName = value;
    notifyListeners();
  }

  //   void updateValidUserBankName(String value) {
  //   _userBankName = '';
  //   if (value.isEmpty) {
  //     _userBankName = 'Chủ thẻ/tài khoản không hợp lệ';
  //     // isEnableButton = false;
  //   } else {
  //     _userBankName = value;
  //     isEnableName = true;
  //     // isEnableButton = true;
  //   }

  //   notifyListeners();
  // }

  void updateUserBankName(String value) {
    _userBankName = value;
    if (!_checkValidUserBankName(value)) {
      _isUserBankNameErr = true;
    } else {
      _isUserBankNameErr = false;
    }
    notifyListeners();
  }

  void updateMerchantName(String value) {
    _merchantName = value;
    if (!_checkValidMerchantName(value.trim())) {
      _isMerchantNameErr = true;
    } else {
      _isMerchantNameErr = false;
    }
    notifyListeners();
  }

  void updateNationalId(String value) {
    _nationalId = value;
    if (!_checkValidNationalId(value.trim())) {
      _isNationalIdErr = true;
    } else {
      _isNationalIdErr = false;
    }
    notifyListeners();
  }

  void updatePhoneAuthenticated(String value) {
    _phoneAuthenticated = value;
    if (!_checkValidPhoneAuthenticated(value.trim())) {
      _isPhoneAuthenticatedErr = true;
    } else {
      _isPhoneAuthenticatedErr = false;
    }
    notifyListeners();
  }

  void doInit() {
    _isMerchantNameErr = false;
    _isBankAccountErr = false;
    _isUserBankNameErr = false;
    _isNationalIdErr = false;
    _isPhoneAuthenticatedErr = false;
    _isAgreePolicy = false;
    //
    _merchantName = '';
    _bankAccount = '';
    _userBankName = '';
    _nationalId = '';
    _phoneAuthenticated = '';
    _otp = '';
    _merchantId = '';
    _confirmId = '';
    notifyListeners();
  }

  bool _checkValidNationalId(String value) {
    bool result = false;
    if (value.isEmpty || value.length < 5) {
      result = false;
    } else {
      result = true;
    }
    return result;
  }

  bool _checkValidPhoneAuthenticated(String value) {
    // Kiểm tra value không rỗng
    if (value.isEmpty) {
      return false;
    }

    // Kiểm tra value chỉ chứa ký tự số
    RegExp numericRegex = RegExp(r'^[0-9]+$');
    if (!numericRegex.hasMatch(value)) {
      return false;
    }

    // Kiểm tra value có độ dài từ 10 đến 12 ký tự
    if (value.length < 10 || value.length > 12) {
      return false;
    }

    // Tất cả các tiêu chí đều được thỏa mãn
    return true;
  }

  bool _checkValidBankAccount(String value) {
    bool result = false;
    if (value.isEmpty || value.length < 4) {
      result = false;
    } else {
      result = true;
    }
    return result;
  }

  bool _checkValidUserBankName(String value) {
    // Kiểm tra field "name" khác empty
    if (value.isEmpty || value.length < 4) {
      return false;
    }

    // Kiểm tra field "name" không chứa ký tự đặc biệt
    RegExp specialCharRegex = RegExp(r'[^\w\s]');
    if (specialCharRegex.hasMatch(value)) {
      return false;
    }

    // Kiểm tra field "name" không chứa dấu tiếng Việt
    RegExp vietnameseRegex = RegExp(r'[^\u0000-\u007F]');
    if (vietnameseRegex.hasMatch(value)) {
      return false;
    }

    return true;
  }

  bool _checkValidMerchantName(String name) {
    // Kiểm tra field "name" khác empty
    if (name.isEmpty || name.length < 4) {
      return false;
    }

    // Kiểm tra field "name" không chứa ký tự đặc biệt
    RegExp specialCharRegex = RegExp(r'[^\w\s]');
    if (specialCharRegex.hasMatch(name)) {
      return false;
    }

    // Kiểm tra field "name" không chứa dấu tiếng Việt
    RegExp vietnameseRegex = RegExp(r'[^\u0000-\u007F]');
    if (vietnameseRegex.hasMatch(name)) {
      return false;
    }

    // Kiểm tra field "name" không chứa khoảng trắng
    if (name.contains(' ')) {
      return false;
    }

    // Tất cả các điều kiện đều passed
    return true;
  }
}
