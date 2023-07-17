import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class CreateQRProvider with ChangeNotifier {
  final moneyController = TextEditingController();
  final contentController = TextEditingController();

  final List<String> listSuggest = [
    'Thanh toán bữa ăn trưa',
    'Chuyển khoản',
  ];

  String money = StringUtils.formatMoney(0.toString());

  String _transactionAmount = '0';
  String _currencyFormatted = '0';

  bool _isQRGenerated = false;

  //errors
  bool _isAmountErr = false;
  bool _isContentErr = false;

  final NumberFormat numberFormat = NumberFormat("##,#0", "en_US");
  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? '0');

  get transactionAmount => _transactionAmount;

  get currencyFormatted => _currencyFormatted;

  get amountErr => _isAmountErr;

  get qrGenerated => _isQRGenerated;

  bool get contentErr => _isContentErr;

  void reset() {
    _transactionAmount = '0';
    _currencyFormatted = '0';
    _isQRGenerated = false;
    _isAmountErr = false;
    _isContentErr = false;
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
      updateMoney(_transactionAmount);
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
      updateMoney(_transactionAmount);
    }

    notifyListeners();
  }

  String _format(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  void updateMoney(String value) {
    money = StringUtils.formatMoney(value);

    value = _formatNumber(value.replaceAll(',', ''));

    moneyController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );

    notifyListeners();
  }

  void updateSuggest(index) {
    contentController.value =
        contentController.value.copyWith(text: listSuggest[index]);
    notifyListeners();
  }
}
