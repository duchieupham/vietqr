import 'package:flutter/material.dart';

class WaterMarkProvider extends ValueNotifier {
  WaterMarkProvider(super.value);

  void updateWaterMark(bool check) {
    value = check;
  }
}
