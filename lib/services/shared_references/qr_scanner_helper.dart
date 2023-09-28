import 'package:vierqr/main.dart';

class QRScannerHelper {
  const QRScannerHelper._privateConstructor();

  static const QRScannerHelper _instance =
      QRScannerHelper._privateConstructor();

  static QRScannerHelper get instance => _instance;

  //
  Future<void> initialQrScanner() async {
    await sharedPrefs.setBool('QR_INTRO', false);
  }

  Future<void> updateQrIntro(bool value) async {
    await sharedPrefs.setBool('QR_INTRO', value);
  }

  bool getQrIntro() {
    return sharedPrefs.getBool('QR_INTRO')!;
  }
}
