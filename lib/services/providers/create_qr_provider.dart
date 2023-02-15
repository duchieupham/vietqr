import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateQRProvider with ChangeNotifier {
  String _transactionAmount = '0';
  String _currencyFormatted = '0';

  bool _isQRGenerated = false;

  //errors
  bool _isAmountErr = false;

  final NumberFormat numberFormat = NumberFormat("##,#0", "en_US");
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? '0');
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  get transactionAmount => _transactionAmount;
  get currencyFormatted => _currencyFormatted;
  get amountErr => _isAmountErr;
  get qrGenerated => _isQRGenerated;

  void reset() {
    _transactionAmount = '0';
    _currencyFormatted = '0';
    _isQRGenerated = false;
    _isAmountErr = false;
    notifyListeners();
  }

  void updateErr(bool amountErr) {
    _isAmountErr = amountErr;
    notifyListeners();
  }

  void updateQrGenerated(bool value) {
    _isQRGenerated = value;
    notifyListeners();
  }

  void updateTransactionAmount(String value) {
    if (_transactionAmount.length <= 9) {
      _transactionAmount += value;
      updateCurrencyFormat(_transactionAmount);
      notifyListeners();
    }
  }

  void clearTransactionAmount() {
    _transactionAmount = '0';
    _currencyFormatted = '0';
    notifyListeners();
  }

  void removeTransactionAmount() {
    if (_transactionAmount.length == 1 || _transactionAmount.isEmpty) {
      _transactionAmount = '0';
      _currencyFormatted = '0';
    } else {
      _transactionAmount =
          _transactionAmount.substring(0, _transactionAmount.length - 1);
      updateCurrencyFormat(_transactionAmount);
    }

    notifyListeners();
  }

  void updateCurrencyFormat(String value) {
    if (value.isNotEmpty && value.characters.first == '0') {
      value = value.substring(1);
      _transactionAmount = _transactionAmount.substring(1);
    }
    if (value.isEmpty) {
      _currencyFormatted = '0';
    } else if (value.length > 3) {
      _currencyFormatted = _formatNumber(value.replaceAll(',', ''));
    } else {
      _currencyFormatted = value;
    }

    notifyListeners();
  }
}
