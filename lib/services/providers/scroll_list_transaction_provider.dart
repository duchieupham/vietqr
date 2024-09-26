import 'package:flutter/material.dart';

class ScrollListTransactionProvider extends ValueNotifier<bool> {
  ScrollListTransactionProvider(super.value);

  void updateScroll(bool isEnableScroll) {
    value = isEnableScroll;
  }
}
