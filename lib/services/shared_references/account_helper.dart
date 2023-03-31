import 'package:vierqr/main.dart';

class AccountHelper {
  const AccountHelper._privateConsrtructor();

  static const AccountHelper _instance = AccountHelper._privateConsrtructor();
  static AccountHelper get instance => _instance;

  Future<void> initialAccountHelper() async {
    await sharedPrefs.setString('TOKEN', '');
    await sharedPrefs.setString('BANK_TOKEN', '');
    await sharedPrefs.setString('FCM_TOKEN', '');
  }

  Future<void> setBankToken(String value) async {
    await sharedPrefs.setString('BANK_TOKEN', value);
  }

  String getBankToken() {
    return sharedPrefs.getString('BANK_TOKEN')!;
  }

  Future<void> setToken(String value) async {
    await sharedPrefs.setString('TOKEN', value);
  }

  String getToken() {
    return sharedPrefs.getString('TOKEN')!;
  }

  Future<void> setFcmToken(String token) async {
    await sharedPrefs.setString('FCM_TOKEN', token);
  }

  String getFcmToken() {
    return sharedPrefs.getString('FCM_TOKEN')!;
  }
}
