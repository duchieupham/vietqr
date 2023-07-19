import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class CreateQRProvider with ChangeNotifier {
  final moneyController = TextEditingController();
  final contentController = TextEditingController();

  String money = StringUtils.formatNumber(0);

  String _transactionAmount = '0';
  String _currencyFormatted = '0';

  bool _isQRGenerated = false;

  //page = 1 : Tạo QR
  //page = 2 : chi tiết QR
  int page = 0;

  //errors
  bool _isAmountErr = false;
  bool _isContentErr = false;

  String? errorAmount;

  get transactionAmount => _transactionAmount;

  get currencyFormatted => _currencyFormatted;

  get amountErr => _isAmountErr;

  get qrGenerated => _isQRGenerated;

  bool get contentErr => _isContentErr;

  File? _imageFile;
  File? _coverImageFile;

  File? get imageFile => _imageFile;

  File? get coverImageFile => _coverImageFile;

  double progressBar = 0.7;

  void updateProgressBar(value) {
    progressBar = value;
    notifyListeners();
  }

  void updatePage(value) {
    page = value;
    notifyListeners();
  }

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

  void updateMoney(String value) {
    errorAmount = null;
    if (value.isNotEmpty) {
      _isAmountErr = true;
      int data = int.parse(value.replaceAll('.', ''));
      if (data < 1000) {
        errorAmount = 'Số tiền phải lớn hơn 1.000';
        _isAmountErr = false;
      }
      money = StringUtils.formatNumber(data);
    } else {
      money = value;
      _isAmountErr = false;
    }

    notifyListeners();
  }

  void updateSuggest(String text) {
    contentController.value = contentController.value.copyWith(text: text);
    notifyListeners();
  }

  void setImage(File? file) {
    _imageFile = file;
    progressBar = 1;
    notifyListeners();
  }
}
