import 'package:vierqr/main.dart';

class AccountHelper {
  const AccountHelper._privateConstructor();

  static const AccountHelper _instance = AccountHelper._privateConstructor();

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

  Future<void> setTokenFree(String value) async {
    await sharedPrefs.setString('TOKEN_FREE', value);
  }

  String getTokenFree() {
    return sharedPrefs.getString('TOKEN_FREE')!;
  }

  Future<void> updateVCard(bool value) async {
    await sharedPrefs.setBool('VCARD', value);
  }

  bool getVCard() {
    return sharedPrefs.getBool('VCARD') ?? false;
  }
}
