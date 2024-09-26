import 'package:flutter/material.dart';

class CheckerProvider extends ValueNotifier {
  CheckerProvider(super.value);

  void updateValue(bool check) {
    value = check;
  }
}
