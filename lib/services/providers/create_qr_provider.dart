import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/mixin/base_manager.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';

import '../../models/qr_box_dto.dart';

class CreateQRProvider with ChangeNotifier, BaseManager {
  @override
  final BuildContext context;

  CreateQRProvider(this.context);

  String money = '';
  String content = '';
  String orderCode = '';
  String branchCode = '';
  String qrBoxCode = '';

  bool isExtra = false;
  bool isQrBox = true;

  List<BankTypeDTO> listBank = [];

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

  bool enableDropList = false;
  TerminalQRDTO terminalQRDTO = TerminalQRDTO();
  QRBoxDTO qrBoxDTO = QRBoxDTO();

  void onMenuStateChange(bool isOpen) {
    if (enableDropList) {
      enableDropList = false;
    }
    notifyListeners();
  }

  void updateTerminalQRDTO(TerminalQRDTO? value, {bool isFirst = false}) {
    if (value == null) return;
    if (value.terminalCode.isEmpty && !isFirst) return;
    terminalQRDTO = value;
    if (!isFirst) {
      branchCode = terminalQRDTO.terminalCode;
    }
    notifyListeners();
  }

  void updateQrBoxDTO(QRBoxDTO? value, {bool isFirst = false}) {
    if (value == null) return;
    if (value.subTerminalCode.isEmpty && !isFirst) return;
    qrBoxDTO = value;
    if (!isFirst) {
      qrBoxCode = qrBoxDTO.subTerminalCode;
    }
    notifyListeners();
  }

  void updateExtra() {
    isExtra = !isExtra;
    notifyListeners();
  }

  void updateisQrBox() {
    isQrBox = !isQrBox;
    branchCode = '';
    qrBoxCode = '';
    notifyListeners();
  }

  void updateProgressBar(value) {
    progressBar = value;
    notifyListeners();
  }

  void updatePage(value) {
    page = value;
    if (listBank.isEmpty) {
      listBank = banks;
    }
    notifyListeners();
  }

  void reset() {
    _isAmountErr = false;
    _isContentErr = false;
    money = StringUtils.formatNumber(0);
    content = '';
    branchCode = '';
    qrBoxCode = '';
    orderCode = '';
    isExtra = false;
    isQrBox = false;
    notifyListeners();
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
    content = text;
    notifyListeners();
  }

  void updateBranchCode(String text) {
    branchCode = text;
    notifyListeners();
  }

  void updateQrBoxCode(String text) {
    qrBoxCode = text;
    notifyListeners();
  }

  void updateOrderCode(String text) {
    orderCode = text;
    notifyListeners();
  }

  void setImage(File? file) {
    _imageFile = file;
    progressBar = 1;
    notifyListeners();
  }
}
