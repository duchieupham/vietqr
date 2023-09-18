import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class CreateQRProvider with ChangeNotifier {
  final moneyController = TextEditingController();
  final contentController = TextEditingController();

  String money = StringUtils.formatNumber(0);

  //page = 1 : Tạo QR
  //page = 2 : chi tiết QR
  int page = -1;

  //errors
  bool _isAmountErr = false;
  bool _isContentErr = false;

  String? errorAmount;

  get amountErr => _isAmountErr;

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
    _isAmountErr = false;
    _isContentErr = false;
    money = StringUtils.formatNumber(0);
  }

  void updateMoney(String value) {
    errorAmount = null;
    if (value.isNotEmpty) {
      _isAmountErr = true;
      int data = int.parse(value.replaceAll(',', ''));
      if (data < 1000) {
        errorAmount = 'Số tiền phải lớn hơn 1,000';
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
