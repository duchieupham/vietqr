// ignore_for_file: constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTheme {
  //COLOR
  static const Color BLACK = Color(0xFF000000);
  static const Color BLACK_DARK = Color(0xFF1B1C1E);
  static const Color BLACK_BUTTON = Color(0xFF303030);
  static const Color BLACK_LIGHT = Color(0xFF464646);
  static const Color WHITE = Color(0xFFFFFFFF);
  static const Color GREY_BUTTON = Color(0xFFEEEFF3);
  static const Color GREY_VIEW = Color(0xFFEEEFF3);
  static const Color GREY_TEXT = Color(0xFF666A72);
  static const Color GREY_LIGHT = Color(0xFF9BA5B9);
  static const Color GREY_BG = Color(0xFFF4F4F4);
  static const Color GREY_HIGHLIGHT = Color(0xFF222222);
  static const Color RED_TEXT = Color(0xFFFF0A0A);
  static const Color BLUE_TEXT = Color(0xFF0A7AFF);
  static const Color RED_CALENDAR = Color(0xFFF5233C);
  static const Color TRANSPARENT = Color(0x00000000);
  static const Color GREY_TOP_TAB_BAR = Color(0xFFBEC1C9);
  static const Color SUCCESS_STATUS = Color(0xFF06B271);
  static const Color GREEN = Color(0xFF00CA28);
  static const Color DARK_GREEN = Color(0xFF0D5F34);
  static const Color BLUE_LIGHT = Color(0xFF96D8FF);
  static const Color DARK_PURPLE = Color(0xFF7951F8);
  static const Color VERY_PERI = Color(0xFF6868AC);
  static const Color LIGHT_PURPLE = Color(0xFFAF93FF);
  static const Color LIGHT_PINK = Color(0xFFFF8AB0);
  static const Color DARK_PINK = Color(0xFFFD246B);
  static const Color NEON = Color(0xFF4DFF34);
  static const Color BLUE_WEATHER = Color(0xFF4BAEB2);
  static const Color RED_NEON = Color(0xFFFF5377);
  static const Color PURPLE_NEON = Color(0xFF605DFF);
  static const Color ORANGE = Color(0xFFFF9C1B);
  static const Color SUNNY_COLOR = Color(0xFFF23535);
  static const Color HOT_COLOR = Color(0xFFE4BE4A);
  static const Color WARM_COLOR = Color(0xFF75F181);
  static const Color COOL_COLOR = Color(0xFF7EE4A7);
  static const Color COLD_COLOR = Color(0xFF52B5D3);
  static const Color WINTER_COLOR = Color(0xFF338AED);
  static const Color RED_NOTI_1 = Color(0xFFFAC4DF);
  static const Color RED_NOTI = Color(0xFFF291BB);
  static const Color GREEN_NOTI_1 = Color(0xFFC4FAEE);
  static const Color GREEN_NOTI = Color(0xFF91F2D9);
  static const Color BANNER_DAY1 = Color(0xFF26B0FD);
  static const Color BLUE_DARK = Color(0xFF014C8B);
  static const Color PURPLE_MIDNIGHT = Color(0xFF3D2BFF);
  static const Color BANNER_NIGHT2 = Color(0xFF0D0132);
  static const Color DARK_NIGHT = Color(0xFF6361C5);
  static const Color LIGHT_DAY = Color(0xFF42D8F2);
  static const Color BANK_CARD_COLOR_1 = Color(0xFFD4D3D1);
  static const Color BANK_CARD_COLOR_2 = Color(0xFFE4E3DF);
  static const Color BANK_CARD_COLOR_3 = Color(0xFFA1A09C);
  static const Color COLOR_CBC2ED = Color(0xFFCBC2ED);
  static const Color COLOR_141CD6 = Color(0xFF141CD6);
  static const Color COLOR_F4272A = Color(0xFFF4272A);

  //THEME NAME
  static const String THEME_LIGHT = 'LIGHT';
  static const String THEME_DARK = 'DARK';
  static const String THEME_SYSTEM = 'SYSTEM';

  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor);
  }
}

//theme data
class DefaultThemeData {
  final BuildContext context;

  const DefaultThemeData({required this.context});

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DefaultTheme.BLACK,
      colorScheme: const ColorScheme.dark(primary: DefaultTheme.GREEN),
      canvasColor: DefaultTheme.GREY_HIGHLIGHT,
      buttonColor: DefaultTheme.BLACK_BUTTON,
      primaryColor: DefaultTheme.BLACK,
      accentColor: DefaultTheme.GREY_LIGHT,
      hoverColor: DefaultTheme.TRANSPARENT,
      toggleableActiveColor: DefaultTheme.BLACK_LIGHT,
      //  focusColor: DefaultTheme.BLUE_TEXT,
      cardColor: DefaultTheme.BLACK_BUTTON,
      shadowColor: DefaultTheme.BLACK_LIGHT,
      hintColor: DefaultTheme.WHITE,
      indicatorColor: DefaultTheme.LIGHT_PINK,
      splashColor: DefaultTheme.TRANSPARENT,
      highlightColor: DefaultTheme.TRANSPARENT,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: DefaultTheme.WHITE,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: DefaultTheme.TRANSPARENT,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
      ),
    );
  }

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: DefaultTheme.GREY_BG,
      colorScheme: const ColorScheme.light(primary: DefaultTheme.GREEN),
      canvasColor: DefaultTheme.GREY_BG,
      buttonColor: DefaultTheme.GREY_VIEW,
      primaryColor: DefaultTheme.WHITE,
      hoverColor: DefaultTheme.TRANSPARENT,
      toggleableActiveColor: DefaultTheme.WHITE,
      // focusColor: DefaultTheme.BLUE_DARK,
      accentColor: DefaultTheme.GREY_TEXT,
      cardColor: DefaultTheme.WHITE,
      shadowColor: DefaultTheme.GREY_TOP_TAB_BAR,
      indicatorColor: DefaultTheme.DARK_PINK,
      hintColor: DefaultTheme.BLACK,
      splashColor: DefaultTheme.TRANSPARENT,
      highlightColor: DefaultTheme.TRANSPARENT,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: DefaultTheme.BLACK,
          ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: DefaultTheme.TRANSPARENT,
      ),
    );
  }
}
