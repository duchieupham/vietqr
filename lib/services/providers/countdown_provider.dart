import 'dart:async';

import 'package:flutter/material.dart';

class CountdownProvider extends ValueNotifier {
  CountdownProvider(super.value);

  void countDown() {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        if (value != 0) value -= 1;
      },
    );
  }
}

class VerifyOtpProvider extends ChangeNotifier {
  String? _otpError;

  get otpError => _otpError;

  bool _isButton = false;

  get isButton => _isButton;

  onChangePinCode(String value) {
    _otpError = null;
    if ((value.isEmpty || value.length < 6) || _isButton) {
      _isButton = false;
    } else {
      _isButton = true;
    }
    notifyListeners();
  }

  onOtpSubmit() {

  }
}
