import 'package:flutter/material.dart';
import 'package:vierqr/models/annual_fee_dto.dart';

class MaintainChargeProvider extends ChangeNotifier {
  bool _isError = false;
  String _bankAccount = '';
  String _bankName = '';
  List<AnnualFeeDTO> listAnnualFee = [];

  get isError => _isError;
  get bankAccount => _bankAccount;
  get bankName => _bankName;

  void selectedBank(String acc, String name) {
    _bankAccount = acc;
    _bankName = name;
  }

  void updateList(List<AnnualFeeDTO> values) {
    listAnnualFee = [...values];
    notifyListeners();
  }

  void setIsError(bool isError) {
    _isError = isError;
    notifyListeners();
  }

  void resetBank() {
    _bankAccount = '';
    _bankName = '';
    notifyListeners();
  }
}
