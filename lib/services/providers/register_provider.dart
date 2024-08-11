import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class RegisterProvider with ChangeNotifier {
  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;

  bool _isConfirmPassErr = false;

  final phoneNoController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPassController = TextEditingController();

  final introduceController = TextEditingController();

  get phoneErr => _isPhoneErr;

  get passwordErr => _isPasswordErr;

  get confirmPassErr => _isConfirmPassErr;

  String _verificationId = '';

  get verificationId => _verificationId;

  int? _resendToken;

  get resendToken => _resendToken;

  get phoneNumberValue => phoneNoController.value;

  final auth = FirebaseAuth.instance;

  static const String countryCode = '+84';

  int _page = 0;

  int get page => _page;

  double height = 0;
  bool isShowButton = false;

  void updateHeight(value, showBT) {
    if (height == 0) {
      height = value;
    }
    isShowButton = showBT;
    notifyListeners();
  }

  void updateVerifyId(value) {
    _verificationId = value;
    notifyListeners();
  }

  void updateResendToken(value) {
    _resendToken = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    String phone = value.replaceAll(" ", "");

    if (phone.isNotEmpty) {
      phoneNoController.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
      var isValid = StringUtils.instance.isValidatePhone(phone);
      _isPhoneErr = !isValid;
    } else {
      _isPhoneErr = false;
    }
    notifyListeners();
  }

  void updatePassword(String value) {
    if (value.isNotEmpty) {
      passwordController.value = passwordController.value.copyWith(text: value);
      _isPasswordErr = false;
    } else {
      _isPasswordErr = true;
    }
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    if (value == passwordController.text &&
        passwordController.text.isNotEmpty) {
      confirmPassController.value =
          confirmPassController.value.copyWith(text: value);
      _isConfirmPassErr = false;
    } else {
      _isConfirmPassErr = value.isEmpty ? false : true;
    }
    notifyListeners();
  }

  void updateErrs({
    required bool phoneErr,
    required bool passErr,
    required bool confirmPassErr,
  }) {
    _isPhoneErr = phoneErr;
    _isPasswordErr = passErr;
    _isConfirmPassErr = confirmPassErr;
    notifyListeners();
  }

  bool isValidValidation() {
    return !_isPhoneErr && !_isPasswordErr && !_isConfirmPassErr;
  }

  bool isValid() {
    return !_isPhoneErr && !_isPasswordErr;
  }

  bool isEnableButton() {
    if (phoneNoController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPassController.text.isNotEmpty) {
      if (isValidValidation()) {
        return true;
      }
    }
    return false;
  }

  // bool isValidValidationPhone() {
  //   return !_isPhoneErr;
  // }

  /// > xu ly validate ????
  bool isEnableButtonPhone() {
    if (phoneNoController.text.isNotEmpty) {
      String phone = phoneNoController.text.replaceAll(' ', '');
      var isValid = StringUtils.instance.isValidatePhone(phone);
      // debugPrint("is Valid ==> $isValid");
      // if (!isValid) {
      //   // _isPhoneErr = false;
      //   return true;
      // }
      return isValid;
    }
    // _isPhoneErr = true;
    return false;
  }

  bool isValidValidationPassword() {
    return !_isPhoneErr && !_isPasswordErr;
  }

  bool isEnableButtonPassword() {
    if (phoneNoController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      if (isValidValidationPassword()) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    _isPhoneErr = false;
    _isPasswordErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }

  void updateIntroduce(String value) {
    introduceController.value = introduceController.value.copyWith(text: value);
    notifyListeners();
  }

  updatePage(int page) {
    _page = page;
    notifyListeners();
  }

  Future<void> phoneAuthentication(String phone,
      {Function(TypeOTP)? onSentOtp}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: countryCode + phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      codeSent: (String verificationId, int? resendToken) {
        updateVerifyId(verificationId);
        updateResendToken(resendToken);
        if (onSentOtp != null) {
          onSentOtp(TypeOTP.SUCCESS);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: (FirebaseAuthException e) {
        if (onSentOtp != null) {
          onSentOtp(TypeOTP.FAILED);
        }
      },
      forceResendingToken: _resendToken,
      timeout: const Duration(seconds: 120),
    );
  }

  Future<dynamic> verifyOTP(String otp) async {
    try {
      var credentials = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otp));
      updateResendToken(null);
      return credentials.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'session-expired') {
        updateResendToken(null);
      }
      return e.code;
    }
  }
}
