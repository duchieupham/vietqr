import 'package:vierqr/commons/enums/text_data.dart';

class StringUtils {
  const StringUtils._privateConsrtructor();

  static const StringUtils _instance = StringUtils._privateConsrtructor();
  static StringUtils get instance => _instance;

  final String _transactionContentWithoutVietnamesePattern =
      r'^[a-zA-Z0-9.,!@#$&*/? ]+$';
  final String _transactionContentPattern = r'^[a-zA-ZÀ-ỹẠ-ỵ0-9.,!@#$&*/? ]+$';

  bool isNumeric(String text) {
    return int.tryParse(text) != null;
  }

  bool isValidPassword(String text) {
    bool check = false;
    if (text.length >= 8 && text.length <= 30) {
      if (text.contains(RegExp(r'^[A-Za-z0-9_.]+$'))) {
        check = true;
      }
    }
    return check;
  }

  bool isValidConfirmText(String text, String confirmText) {
    return text.trim() == confirmText.trim();
  }

  bool isValidTransactionContent(String text) {
    bool result = false;
    final RegExp regExp = RegExp(_transactionContentPattern);
    if (regExp.hasMatch(text)) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  bool isValidTransactionWithoutVietnameseContent(String text) {
    bool result = false;
    final RegExp regExp = RegExp(_transactionContentWithoutVietnamesePattern);
    if (regExp.hasMatch(text)) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  String removeDiacritic(String input) {
    String result = '';
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final replacedChar = diacriticsMap[char] ?? char;
      result += replacedChar;
    }
    return result;
  }
}
