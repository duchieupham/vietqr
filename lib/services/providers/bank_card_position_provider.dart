import 'package:flutter/material.dart';

class BankCardPositionProvider extends ValueNotifier {
  BankCardPositionProvider(super.value);

  void transform() {
    value = true;
  }

  void reset() {
    value = false;
  }
}
