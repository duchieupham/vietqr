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

  Future<void> updateLogoTheme(String theme) async {
    if (!sharedPrefs.containsKey('LOGO_THEME') ||
        sharedPrefs.getString('LOGO_THEME') == null) {
      await sharedPrefs.setString('LOGO_THEME', theme);
      return;
    }
    await sharedPrefs.setString('LOGO_THEME', theme);
  }

  String getLogoTheme() {
    return sharedPrefs.getString('LOGO_THEME') ?? '';
  }

  Future<void> updateThemeKey(int theme) async {
    if (!sharedPrefs.containsKey('THEME_KEY') ||
        sharedPrefs.getInt('THEME_KEY') == null) {
      await sharedPrefs.setInt('THEME_KEY', theme);
      return;
    }
    await sharedPrefs.setInt('THEME_KEY', theme);
  }

  int getThemeKey() {
    return sharedPrefs.getInt('THEME_KEY') ?? -1;
  }

  Future<void> updateLogoVer(int theme) async {
    if (!sharedPrefs.containsKey('LOGO_VER') ||
        sharedPrefs.getInt('LOGO_VER') == null) {
      await sharedPrefs.setInt('LOGO_VER', theme);
      return;
    }
    await sharedPrefs.setInt('LOGO_VER', theme);
  }

  int getLogoVer() {
    return sharedPrefs.getInt('LOGO_VER') ?? -1;
  }
}
