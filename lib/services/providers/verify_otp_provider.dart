import 'dart:async';

import 'package:flutter/material.dart';

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

  static const sessionExpired = 'session-expired';
  static const invalidCode = 'invalid-verification-code';

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

  reset() {
    _isLoading = false;
    _isButton = false;
    _otpError = null;
    notifyListeners();
  }
}
