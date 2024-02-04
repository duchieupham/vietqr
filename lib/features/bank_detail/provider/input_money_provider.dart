import 'package:flutter/material.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/qr_bank_detail.dart';

class InputMoneyProvider with ChangeNotifier {
  String money = StringUtils.formatNumber(0);
  String content = '';
  String errorAmount = '';

  bool _isAmountErr = false;

  bool get amountErr => _isAmountErr;

  init(String bankAccount) {
    List<QRDetailBank> qrBankDetail = [];
    qrBankDetail = AppDataHelper.instance.qrDetailBanks;

    if (qrBankDetail.isNotEmpty) {
      qrBankDetail.forEach((qrBankDetail) {
        if (qrBankDetail.bankAccount == bankAccount) {
          content = qrBankDetail.content;
          int data = int.parse(qrBankDetail.money.replaceAll(',', ''));
          money = StringUtils.formatNumber(data);
        }
      });
    }
  }

  void updateMoney(String value) {
    errorAmount = '';
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
    content = text;
    notifyListeners();
  }

  updateContent(String value) {
    content = value;
    notifyListeners();
  }
}
