import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:vierqr/commons/enums/text_data.dart';

class StringUtils {
  const StringUtils._privateConsrtructor();

  static const StringUtils _instance = StringUtils._privateConsrtructor();

  static StringUtils get instance => _instance;

  final String _transactionContentWithoutVietnamesePattern =
      r'^[a-zA-Z0-9.,!@#$&*/? ]+$';
  final String _transactionContentPattern = r'^[a-zA-ZÀ-ỹẠ-ỵ0-9.,!@#$&*/? ]+$';
  final String _fullNamePattern = r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$';
  final String _phonePattern = r'^(?:[+0]9)?[0-9]{10}$';

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

  bool isValidFullName(String text) {
    bool result = false;
    final RegExp regExp = RegExp(_fullNamePattern);
    if (text.isNotEmpty) {
      if (regExp.hasMatch(text)) {
        result = true;
      }
    }
    return result;
  }

  bool isValidTransactionContent(String text) {
    bool result = false;
    final RegExp regExp = RegExp(_transactionContentPattern);
    if (text.isNotEmpty) {
      if (regExp.hasMatch(text)) {
        result = true;
      }
    } else {
      result = true;
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

  String capitalFirstCharacter(String paragraph) {
    String result = '';
    result = paragraph
        .toLowerCase()
        .trim()
        .split(" ")
        .map((str) => toBeginningOfSentenceCase(str))
        .join(" ");
    return result;
  }

  List<String> splitFullName(String fullName) {
    List<String> nameParts = fullName.trim().split(' ');
    String lastName = nameParts[0];
    String firstName = nameParts.last;
    String middleName = '';
    if (nameParts.length > 2) {
      List<String> middleNames = nameParts.sublist(1, nameParts.length - 1);
      middleName = middleNames.join(' ');
    }
    return [firstName, middleName, lastName];
  }

  String? validatePhone(String value) {
    RegExp regExp = RegExp(_phonePattern);
    if (value.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return 'Số điện thoại không đúng định dạng.';
    }
    return null;
  }

  bool? isValidatePhone(String value) {
    RegExp regExp = RegExp(_phonePattern);
    if (value.isEmpty || value.length > 10 || value.length < 10) {
      return true;
    } else if (!regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static String formatMoney(String money) {
    if (money.length > 2) {
      var value = money;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      return value;
    }
    return money;
  }

  static String formatNumber(dynamic value) {
    if (value == null) {
      return '0';
    }
    var numberFormat = NumberFormat.decimalPattern('en');
    return numberFormat.format(value);
  }

  String formatPhoneNumberVN(String phoneNumber) {
    String numericString = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericString.length >= 10) {
      return phoneNumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'),
          (Match m) => "${m[1]} ${m[2]} ${m[3]}");
    } else {
      if (numericString.length == 8) {
        return '${numericString.substring(0, 4)} ${numericString.substring(4, 8)}';
      }
      return numericString;
    }
  }

  static bool isValidUrl(String url) {
    // Sử dụng regex để kiểm tra định dạng URL
    RegExp urlRegExp = RegExp(
      r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
      caseSensitive: false,
      multiLine: false,
    );

    return urlRegExp.hasMatch(url);
  }

  String authBase64() {
    final username = "system-mobile-app";
    final password = "c3lzdGVtLW1vYmlsZS1hcHA=";

    String credentials = "$username:$password";
    String credentialsBase64 = base64Encode(utf8.encode(credentials));
    return credentialsBase64;
  }
}
