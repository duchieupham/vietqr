import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/main.dart';

class ThemeHelper {
  const ThemeHelper._privateConstructor();

  static const ThemeHelper _instance = ThemeHelper._privateConstructor();

  static ThemeHelper get instance => _instance;

  //
  Future<void> initialTheme() async {
    await sharedPrefs.setString('THEME_SYSTEM', AppColor.THEME_SYSTEM);
  }

  Future<void> updateTheme(String theme) async {
    await sharedPrefs.setString('THEME_SYSTEM', theme);
  }

  String getTheme() {
    return sharedPrefs.getString('THEME_SYSTEM')!;
  }

  Future<void> updateKeepBright(bool theme) async {
    if (!sharedPrefs.containsKey('KEEP_BRIGHT') ||
        sharedPrefs.getBool('KEEP_BRIGHT') == null) {
      await sharedPrefs.setBool('KEEP_BRIGHT', false);
      return;
    }
    await sharedPrefs.setBool('KEEP_BRIGHT', theme);
  }

  bool getKeepBright() {
    return sharedPrefs.getBool('KEEP_BRIGHT') ?? false;
  }

  Future<void> updateThemeKey(int theme) async {
    if (!sharedPrefs.containsKey('THEME_KEY') ||
        sharedPrefs.getInt('THEME_KEY') == null) {
      await sharedPrefs.setInt('THEME_KEY', -1);
      return;
    }
    await sharedPrefs.setInt('THEME_KEY', theme);
  }

  int getThemeKey() {
    return sharedPrefs.getInt('THEME_KEY') ?? -1;
  }
}
