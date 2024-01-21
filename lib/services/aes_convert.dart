import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';

class AESConvert {
  static String keyAES = 'keyencryptdevietqrloginqrbyaes01';
  static String accessKeyLoginWeb = 'VIETQRVNBNSAccessKeyForLoginWEB';
  static String accessKeyTokenPlugin = 'VIETQRVNBNSAccessKeyForTokenPLUGIN';
  static String replaceLoginWeb = 'LOGIN';
  static String replaceWordPress = 'ECLOGIN';

  static String encrypt(String value) {
    final key = Key.fromUtf8(keyAES);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));

    final encrypted = encrypter.encrypt(value, iv: iv);
    print('Encrypted: ${encrypted.base64}');
    return encrypted.base64;
  }

  static decrypt(String value, {AESMode? mode}) {
    final key = Key.fromUtf8(keyAES);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: mode ?? AESMode.ecb));

    return encrypter.decrypt64(value, iv: iv);
  }

  static String getEncryptedString(String loginID) {
    Uuid uuid = const Uuid();

    String randomKey = uuid.v4();

    return 'LOGIN$randomKey$accessKeyLoginWeb$loginID';
  }

  static List<String> splitsKey(String code,
      {String? replace, String? accessKey}) {
    String dec = decrypt(code);
    dec = dec.replaceAll(replace ?? replaceLoginWeb, '');
    if (dec.contains(accessKey ?? accessKeyLoginWeb)) {
      List<String> splits = dec.split(accessKey ?? accessKeyLoginWeb);
      if (splits.isNotEmpty) {
        return splits;
      }
    }
    return [];
  }
}
