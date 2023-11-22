import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';

class CountDownOTPNotifier extends ValueNotifier {
  CountDownOTPNotifier(super.value);

  Timer? _timer;

  int _resendOtp = 3;

  get resendOtp => _resendOtp;

  late DateTime timePause;
  int otpDurationPause = 0;

  void countDown() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        if (value != 0) {
          value--;
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  setValue(data) => value = data;

  resendCountDown({data}) {
    if (value <= 0) {
      _resendOtp -= 1;
      setValue(data ?? 120);
      countDown();
    }
  }

  void onHideApp(state) {
    if (_timer == null || !_timer!.isActive) {
      return;
    }
    if (state == AppLifecycleState.paused) {
      timePause = DateTime.now();
      otpDurationPause = value;
    } else if (state == AppLifecycleState.resumed) {
      DateTime timeResumed = DateTime.now();
      int timeRange = timeResumed.difference(timePause).inSeconds;
      if (timeRange > 0 && otpDurationPause != value) {
        value = otpDurationPause - timeRange;
        if (value < 0) {
          value = 0;
          if (_resendOtp <= 0) {
            _timer!.cancel();
            return;
          }
        }
      }
    }
  }
}

class VerifyOtpProvider extends ChangeNotifier {
  String? _otpError;

  get otpError => _otpError;

  bool _isButton = false;

  get isButton => _isButton;

  bool _isLoading = false;

  get isLoading => _isLoading;

  final auth = FirebaseAuth.instance;
  static const String countryCode = '+84';

  String _verificationId = '';

  get verificationId => _verificationId;

  int? _resendToken;

  get resendToken => _resendToken;

  static const sessionExpired = 'session-expired';
  static const invalidCode = 'invalid-verification-code';
  static const tooManyRQ = 'too-many-requests';
  static const invalidPhone = 'invalid-phone-number';

  updateLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  onChangePinCode(String value) {
    _otpError = null;
    if ((value.isEmpty || value.length < 6) || _isButton) {
      _isButton = false;
    } else {
      _isButton = true;
    }
    notifyListeners();
  }

  onOtpSubmit(String value, Function() resetTime) {
    switch (value) {
      case sessionExpired:
        _otpError = 'Mã OTP đã hết hạn. Vui lòng gửi lại mã OTP để thử lại.';
        _isButton = false;
        resetTime();
        updateLoading(false);
        break;
      case invalidCode:
        _otpError = 'Mã OTP không hợp lệ. Vui lòng nhập OTP để thử lại.';
        _isButton = false;
        updateLoading(false);
        break;
      default:
        _otpError = null;
        _isButton = false;
        resetTime();
        updateLoading(false);
    }
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
        if (e.code == tooManyRQ) {
          _otpError = 'Mã OTP đã được gửi nhiều lần. Vui lòng thử lại sau.';
        } else if (e.code == invalidPhone) {
          _otpError = 'Số điện thoại không hợp lệ. Vui lòng thử lại.';
        } else {
          _otpError = 'Hệ thống OTP đang bảo trì. Vui lòng thử lại sau.';
        }
        notifyListeners();
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
      if (e.code == sessionExpired) {
        updateResendToken(null);
      }
      _otpError = 'Mã OTP không hợp lệ. Vui lòng thử lại.';
      notifyListeners();
      return null;
    }
  }

  void setError(String value) {
    _otpError = value;
    notifyListeners();
  }

  reset() {
    _isLoading = false;
    _isButton = false;
    _otpError = null;
    notifyListeners();
  }

  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool _isConfirmPassErr = false;
  bool _isPasswordErr = false;

  get passwordErr => _isPasswordErr;

  get confirmPassErr => _isConfirmPassErr;

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
      _isConfirmPassErr = true;
    }
    notifyListeners();
  }

  bool isEnable() {
    return (passwordController.text.isNotEmpty &&
        passwordController.text.length >= 6 &&
        passwordController.text == confirmPassController.text);
  }
}
