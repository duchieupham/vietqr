import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/main.dart';

class ThemeHelper {
  const ThemeHelper._privateConsrtructor();

  static const ThemeHelper _instance = ThemeHelper._privateConsrtructor();
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
}
