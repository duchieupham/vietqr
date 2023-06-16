import 'package:flutter/material.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/services/shared_references/bank_arrangement_helper.dart';

class BankArrangementProvider with ChangeNotifier {
  //type = 0 => stack
  //type = 1 => slide
  int _type = BankArrangementHelper.instance.getBankArr();

  int get type => _type;

  Future<void> updateBankArr(int value) async {
    await BankArrangementHelper.instance.updateBankArr(value);
    _type = BankArrangementHelper.instance.getBankArr();
    eventBus.fire(ChangeThemeEvent());
    notifyListeners();
  }
}
