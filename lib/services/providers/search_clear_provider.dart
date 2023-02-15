import 'package:flutter/material.dart';

class SearchClearProvider extends ValueNotifier {
  SearchClearProvider(super.value);

  void updateClearSearch(bool check) {
    value = check;
  }
}
