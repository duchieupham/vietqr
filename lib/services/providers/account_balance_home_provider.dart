import 'package:flutter/material.dart';

class AccountBalanceHomeProvider extends ValueNotifier {
  AccountBalanceHomeProvider(super.value);

  void updateAccountBalance(String accountBalance) {
    value = accountBalance;
  }
}
