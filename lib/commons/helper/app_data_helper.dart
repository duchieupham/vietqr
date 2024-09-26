import 'package:vierqr/models/qr_bank_detail.dart';

class AppDataHelper {
  AppDataHelper._privateConstructor();

  static final AppDataHelper _instance = AppDataHelper._privateConstructor();

  static AppDataHelper get instance => _instance;

  final List<QRDetailBank> _qrDetailBanks = [];
  List<QRDetailBank> get qrDetailBanks => _qrDetailBanks;

  addListQRDetailBank(QRDetailBank value) async {
    if (_qrDetailBanks.isNotEmpty) {
      if (checkExitsQRDetailBank(value)) {
        _qrDetailBanks
            .removeWhere((element) => element.bankAccount == value.bankAccount);
        _qrDetailBanks.add(value);
      } else {
        _qrDetailBanks.add(value);
      }
    } else {
      _qrDetailBanks.add(value);
    }
  }

  bool checkExitsQRDetailBank(QRDetailBank qr) {
    bool value = false;
    for (var element in _qrDetailBanks) {
      if (element.bankAccount == qr.bankAccount) {
        value = true;
      }
    }
    return value;
  }

  bool checkExitsBankAccount(String bankAccount) {
    bool value = false;
    for (var element in _qrDetailBanks) {
      if (element.bankAccount == bankAccount) {
        value = true;
      }
    }
    return value;
  }

  QRDetailBank getQrcodeByBankAccount(String bankAccount) {
    QRDetailBank value = QRDetailBank();
    for (var element in _qrDetailBanks) {
      if (element.bankAccount == bankAccount) {
        value = element;
      }
    }
    return value;
  }

  removeAtBankAccount(String bankAccount) {
    bool value = false;
    _qrDetailBanks.removeWhere((element) => element.bankAccount == bankAccount);

    return value;
  }

  clearListQRDetailBank() async {
    _qrDetailBanks.clear();
  }
}
