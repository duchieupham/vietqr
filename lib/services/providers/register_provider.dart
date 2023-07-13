import 'package:flutter/material.dart';

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

  // final auth = FirebaseAuth.instance;

  static const String countryCode = '+84';

  void updateVerifyId(value) {
    _verificationId = value;
    notifyListeners();
  }

  void updateResendToken(value) {
    _resendToken = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    if (value.isNotEmpty) {
      phoneNoController.value = phoneNoController.value.copyWith(text: value);
      _isPhoneErr = false;
    } else {
      _isPhoneErr = true;
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

  void reset() {
    _isPhoneErr = false;
    _isPasswordErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }

  void updateRePass(String value) {
    if (value.isNotEmpty) {
      confirmPassController.value =
          confirmPassController.value.copyWith(text: value);
      if (value != passwordController.text) {
        _isConfirmPassErr = true;
      } else {
        _isConfirmPassErr = false;
      }
    } else {
      _isConfirmPassErr = true;
    }

    notifyListeners();
  }

  void updateIntroduce(String value) {
    introduceController.value = introduceController.value.copyWith(text: value);
    notifyListeners();
  }

// Future<void> phoneAuthentication(String phone,
//     {Function(TypeOTP)? onSentOtp}) async {
//   await auth.verifyPhoneNumber(
//     phoneNumber: countryCode + phone,
//     verificationCompleted: (PhoneAuthCredential credential) async {},
//     codeSent: (String verificationId, int? resendToken) {
//       updateVerifyId(verificationId);
//       updateResendToken(resendToken);
//       if (onSentOtp != null) {
//         onSentOtp(TypeOTP.SUCCESS);
//       }
//     },
//     codeAutoRetrievalTimeout: (String verificationId) {},
//     verificationFailed: (FirebaseAuthException e) {
//       if (onSentOtp != null) {
//         onSentOtp(TypeOTP.FAILED);
//       }
//     },
//     forceResendingToken: _resendToken,
//     timeout: const Duration(seconds: 120),
//   );
// }
//
// Future<dynamic> verifyOTP(String otp, Function onLoading) async {
//   try {
//     onLoading();
//     var credentials = await auth.signInWithCredential(
//         PhoneAuthProvider.credential(
//             verificationId: verificationId, smsCode: otp));
//     updateResendToken(null);
//     return credentials.user != null;
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'session-expired') {
//       updateResendToken(null);
//     }
//     return e.code;
//   }
// }
}
