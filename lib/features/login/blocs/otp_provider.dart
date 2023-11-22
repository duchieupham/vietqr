import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

class OTPProvider with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  static const String countryCode = '+84';

  String _verificationId = '';

  get verificationId => _verificationId;

  int? _resendToken;

  get resendToken => _resendToken;

  void updateVerifyId(value) {
    _verificationId = value;
    notifyListeners();
  }

  void updateResendToken(value) {
    _resendToken = value;
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
        TypeOTP type = TypeOTP.NONE;
        if (e.code == 'too-many-requests') {
          type = TypeOTP.TOO_MANY_REQUEST;
        }

        if (onSentOtp != null) {
          onSentOtp(type);
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
