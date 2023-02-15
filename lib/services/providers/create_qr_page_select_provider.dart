import 'package:vierqr/models/bank_account_dto.dart';
import 'package:flutter/material.dart';

class CreateQRPageSelectProvider with ChangeNotifier {
  int _indexSelected = 0;

  // BankAccountDTO _bankAccountDTO = const BankAccountDTO(
  //   bankAccount: '',
  //   bankAccountName: '',
  //   bankName: 'Chọn ngân hàng để tạo mã QR',
  //   bankCode: '',
  // );

  get indexSelected => _indexSelected;
  // get bankAccountDTO => _bankAccountDTO;

  void updateIndex(int index) {
    _indexSelected = index;
    notifyListeners();
  }

  // void updateBankAccountDTO(BankAccountDTO dto) {
  //   _bankAccountDTO = dto;
  //   notifyListeners();
  // }

  void reset() {
    _indexSelected = 0;
    // _bankAccountDTO = const BankAccountDTO(
    //   bankAccount: '',
    //   bankAccountName: '',
    //   bankName: 'Chọn ngân hàng để tạo mã QR',
    //   bankCode: '',
    // );
    notifyListeners();
  }
}
