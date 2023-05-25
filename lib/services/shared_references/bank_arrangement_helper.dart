import 'package:vierqr/main.dart';

class BankArrangementHelper {
  const BankArrangementHelper._privateConsrtructor();

  static const BankArrangementHelper _instance =
      BankArrangementHelper._privateConsrtructor();
  static BankArrangementHelper get instance => _instance;
  //
  Future<void> initialBankArr() async {
    await sharedPrefs.setInt('BANK_ARRANGEMENT', 0);
  }

  Future<void> updateBankArr(int value) async {
    await sharedPrefs.setInt('BANK_ARRANGEMENT', value);
  }

  int getBankArr() {
    return sharedPrefs.getInt('BANK_ARRANGEMENT')!;
  }
}
