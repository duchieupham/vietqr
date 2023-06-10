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
