class StringUtils {
  const StringUtils._privateConsrtructor();

  static const StringUtils _instance = StringUtils._privateConsrtructor();
  static StringUtils get instance => _instance;

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
}
