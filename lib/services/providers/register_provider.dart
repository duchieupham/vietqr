import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/check_type.dart';

class RegisterProvider with ChangeNotifier {
  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;
  bool _isConfirmPassErr = false;

  get phoneErr => _isPhoneErr;

  get passwordErr => _isPasswordErr;

  get confirmPassErr => _isConfirmPassErr;

  String _verificationId = '';

  get verificationId => _verificationId;

  int? _resendToken;

  get resendToken => _resendToken;

  final auth = FirebaseAuth.instance;

  static const String countryCode = '+84';

  void updateVerifyId(value) {
    _verificationId = value;
    notifyListeners();
  }

  void updateResendToken(value) {
    _resendToken = value;
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

  void reset() {
    _isPhoneErr = false;
    _isPasswordErr = false;
    _isConfirmPassErr = false;
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

  Future<dynamic> verifyOTP(String otp, Function onLoading) async {
    try {
      onLoading();
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
