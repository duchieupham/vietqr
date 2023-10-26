import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';

class AESConvert {
  static String keyAES = 'keyencryptdevietqrloginqrbyaes01';
  static String accessKey = 'VIETQRVNBNSAccessKeyForLoginWEB';

  static String encrypt(String value) {
    final key = Key.fromUtf8(keyAES);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(value, iv: iv);
    print('Encrypted: ${encrypted.base64}');
    return encrypted.base64;
  }

  static decrypt(String value) {
    final key = Key.fromUtf8(keyAES);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    return encrypter.decrypt64(value, iv: iv);
  }

  static String getEncryptedString(String loginID) {
    Uuid uuid = const Uuid();

    String randomKey = uuid.v4();

    return 'LOGIN$randomKey$accessKey$loginID';
  }

  static String getLoginID() {
    Uuid uuid = const Uuid();
    String loginId = uuid.v4();
    return loginId;
  }
}
