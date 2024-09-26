import 'dart:async';

import 'package:flutter/material.dart';

class CountdownProvider extends ValueNotifier<int> {
  CountdownProvider(super.value);

  Timer? _timer;

  setValue(int value) {
    this.value = value;
  }

  void countDown({VoidCallback? callback}) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        if (value != 0) value -= 1;
        if (value == 0 && callback != null) {
          callback.call();
          _timer!.cancel();
        }
      },
    );
  }
}
