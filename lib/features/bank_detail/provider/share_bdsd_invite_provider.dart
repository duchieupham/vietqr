import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class ShareBDSDInviteProvider with ChangeNotifier {
  List<BankAccountDTO> _bankAccounts = [];

  List<BankAccountDTO> get bankAccounts => _bankAccounts;

  void addListBankAccount(BankAccountDTO value) {
    _bankAccounts.add(value);
    notifyListeners();
  }
}
