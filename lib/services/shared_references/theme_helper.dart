import 'package:vierqr/main.dart';

class ThemeHelper {
  const ThemeHelper._privateConstructor();

  static const ThemeHelper _instance = ThemeHelper._privateConstructor();

  static ThemeHelper get instance => _instance;

  //Dùng để update list themes
  static String theme_version = 'THEME_VERSION';
  static String logo_version = 'LOGO_VERSION';
  static String logo_theme = 'LOGO_THEME_v2';
  static String theme_system = 'THEME_v2';
  static String event_theme = 'EVENT_THEME';
  static String update_app = 'UPDATE_APP';

  void clearTheme() async {
    await updateThemeVer('');
    await updateLogoVer('');
    await updateLogoTheme('');
    await updateThemeSystem('');
  }

  Future<void> updateApp(bool theme) async {
    if (!sharedPrefs.containsKey(update_app) ||
        sharedPrefs.getBool(update_app) == null) {
      await sharedPrefs.setBool(update_app, theme);
      return;
    }
    await sharedPrefs.setBool(update_app, theme);
  }

  bool getUpdateApp() {
    return sharedPrefs.getBool(update_app) ?? false;
  }

  Future<void> updateLogoTheme(String theme) async {
    if (!sharedPrefs.containsKey(logo_theme) ||
        sharedPrefs.getString(logo_theme) == null) {
      await sharedPrefs.setString(logo_theme, theme);
      return;
    }
    await sharedPrefs.setString(logo_theme, theme);
  }

  String getLogoTheme() {
    return sharedPrefs.getString(logo_theme) ?? '';
  }

  /// Theme version màn Dashboard
  Future<void> updateThemeVer(String theme) async {
    if (!sharedPrefs.containsKey(theme_version) ||
        sharedPrefs.getString(theme_version) == null) {
      await sharedPrefs.setString(theme_version, theme);
      return;
    }
    await sharedPrefs.setString(theme_version, theme);
  }

  String getThemeVer() {
    return sharedPrefs.getString(theme_version) ?? '';
  }

  /// Logo version màn login
  Future<void> updateLogoVer(String version) async {
    if (!sharedPrefs.containsKey(logo_version) ||
        sharedPrefs.getString(logo_version) == null) {
      await sharedPrefs.setString(logo_version, version);
      return;
    }
    await sharedPrefs.setString(logo_version, version);
  }

  String getLogoVer() {
    return sharedPrefs.getString(logo_version) ?? '';
  }

  /// Theme màn login
  Future<void> updateThemeSystem(String theme) async {
    if (!sharedPrefs.containsKey(theme_system) ||
        sharedPrefs.getString(theme_system) == null) {
      await sharedPrefs.setString(theme_system, theme);
      return;
    }
    await sharedPrefs.setString(theme_system, theme);
  }

  String getThemeSystem() {
    return sharedPrefs.getString(theme_system) ?? '';
  }

  /// Theme khi set sự kiện
  Future<void> updateEventTheme(bool theme) async {
    if (!sharedPrefs.containsKey(event_theme) ||
        sharedPrefs.getBool(event_theme) == null) {
      await sharedPrefs.setBool(event_theme, theme);
      return;
    }
    await sharedPrefs.setBool(event_theme, theme);
  }

  bool getEventTheme() {
    return sharedPrefs.getBool(event_theme) ?? false;
  }
}
