import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/string_utils.dart';

class ShowQRProvider with ChangeNotifier {
  String money = StringUtils.formatNumber(0);

  final String _transactionAmount = '0';
  final String _currencyFormatted = '0';

  final bool _isQRGenerated = false;

  //errors
  final bool _isAmountErr = false;
  final bool _isContentErr = false;

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

  void setImage(File? file) {
    _imageFile = file;
    progressBar = 1;
    notifyListeners();
  }
}
