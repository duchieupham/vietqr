import 'package:flutter/material.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/store/merchant_dto.dart';

import 'package:vierqr/models/terminal_qr_dto.dart';

class QRBoxProvider extends ChangeNotifier {
  List<TerminalQRDTO> listTerminal = [];
  List<TerminalQRDTO> filterTerminals = [];
  List<BankAccountDTO> listAuthBank = [];
  List<MerchantDTO> listMerchant = [];

  BankAccountDTO? selectBank;
  TerminalQRDTO? selectTerminal;
  MerchantDTO? selectMerchant;

  bool isFilter = false;

  init(List<BankAccountDTO> list) {
    listAuthBank = list;
    listTerminal = [];
    filterTerminals = [];
    listMerchant = [];
    selectBank = null;
    selectMerchant = null;
    selectTerminal = null;
    notifyListeners();
  }

  void filterTerminal(String filter) {
    if (filter.isNotEmpty) {
      isFilter = true;
      filterTerminals = listTerminal
          .where((element) =>
              element.terminalName.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      isFilter = false;
    }

    notifyListeners();
  }

  void updateMerchants(List<MerchantDTO> list) {
    listMerchant = list;
    notifyListeners();
  }

  void updateTerminals(List<TerminalQRDTO> list) {
    listTerminal = list;
    notifyListeners();
  }

  void bankSelect(BankAccountDTO? dto) {
    selectBank = dto;
    notifyListeners();
  }

  void merchantSelect(MerchantDTO? dto) {
    selectMerchant = dto;
    notifyListeners();
  }

  void terminalSelect(TerminalQRDTO? dto) {
    selectTerminal = dto;
    notifyListeners();
  }
}
