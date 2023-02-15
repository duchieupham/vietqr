import 'package:vierqr/main.dart';

class CreateQRHelper {
  const CreateQRHelper._privateConsrtructor();

  static const CreateQRHelper _instance = CreateQRHelper._privateConsrtructor();
  static CreateQRHelper get instance => _instance;
  //
  Future<void> initialCreateQRHelper() async {
    await sharedPrefs.setString('TRANSACTION_AMOUNT', '');
    await sharedPrefs.setString('TRANSACTION_CONTENT', '');
  }

  Future<void> updateTransactionAmount(String value) async {
    await sharedPrefs.setString('TRANSACTION_AMOUNT', value);
  }

  Future<void> updateTransactionContent(String value) async {
    await sharedPrefs.setString('TRANSACTION_CONTENT', value);
  }

  String getTransactionAmount() {
    if (!sharedPrefs.containsKey('TRANSACTION_AMOUNT') ||
        sharedPrefs.getString('TRANSACTION_AMOUNT') == null) {
      initialCreateQRHelper();
    }
    return sharedPrefs.getString('TRANSACTION_AMOUNT')!;
  }

  String getTransactionContent() {
    if (!sharedPrefs.containsKey('TRANSACTION_CONTENT') ||
        sharedPrefs.getString('TRANSACTION_CONTENT') == null) {
      initialCreateQRHelper();
    }
    return sharedPrefs.getString('TRANSACTION_CONTENT')!;
  }
}
