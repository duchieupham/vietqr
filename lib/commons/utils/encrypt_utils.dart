import 'dart:convert';

import 'package:crypto/crypto.dart';

class EncryptUtils {
  const EncryptUtils._privateConsrtructor();

  static const EncryptUtils _instance = EncryptUtils._privateConsrtructor();
  static EncryptUtils get instance => _instance;

  String encrypted(String prefix, String textEncrypt) {
    String result = '';
    List<int> key = utf8.encode(prefix);
    List<int> data = utf8.encode(textEncrypt);
    Hmac hmacSHA256 = Hmac(sha256, key);
    Digest digest = hmacSHA256.convert(data);
    result = digest.toString();
    return result;
  }
}
