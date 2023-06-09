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

  TypeOTP _typeSentOtp = TypeOTP.NONE;

  get typeSentOtp => _typeSentOtp;

  final auth = FirebaseAuth.instance;

  static const String countryCode = '+84';

  void updateVerifyId(value) {
    _verificationId = value;
    notifyListeners();
  }

  void updateSentOtp(value) {
    _typeSentOtp = value;
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

  Future<void> phoneAuthentication(
      String phone, Function(TypeOTP) onSentOtp) async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+840972574143',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      codeSent: (String verificationId, int? resendToken) {
        updateVerifyId(verificationId);
        updateSentOtp(TypeOTP.SUCCESS);
        onSentOtp(TypeOTP.SUCCESS);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: (FirebaseAuthException e) {
        onSentOtp(TypeOTP.FAILED);
      },
      timeout: const Duration(seconds: 10),
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
