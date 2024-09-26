// ignore_for_file: constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColor {
  //COLOR
  static const Color BLACK = Color(0xFF000000);

  static const Color BLACK_TEXT = Color(0xff393939);
  static const Color BLACK_DARK = Color(0xFF1B1C1E);
  static const Color BLACK_BUTTON = Color(0xFF303030);
  static const Color BLACK_LIGHT = Color(0xFF464646);
  static const Color WHITE = Color(0xFFFFFFFF);
  static const Color GREY_BUTTON = Color(0xFFEEEFF3);
  static const Color GREY_VIEW = Color(0xFFEEEFF3);
  static const Color GREY_TEXT = Color(0xFF666A72);
  static const Color GREY_BORDER = Color(0xFFF4F4F4);
  static const Color GREY_LIGHT = Color(0xFF9BA5B9);
  static const Color GREY_EBEBEB = Color(0xFFebebeb);
  static const Color GREY_BG = Color(0xFFF4F4F4);
  static const Color GREY_979797 = Color(0xff979797);
  static const Color GREY_F1F2F5 = Color(0xFFF1F2F5);
  static const Color GREY_HIGHLIGHT = Color(0xFF222222);
  static const Color GREY_444B56 = Color(0xff444B56);
  static const Color RED_TEXT = Color(0xFFFF0A0A);
  static const Color RED_EC1010 = Color(0xffEC1010);
  static const Color RED_FFFF0000 = Color(0xFFFF0000);
  static const Color BLUE_E1EFFF = Color(0xFFE1EFFF);
  static const Color BLUE_E5F9FF = Color(0xFFE5F9FF);
  static const Color BLUE_BGR = Color(0xFFF0F4FA);

  // static const Color BLUE_91FFFF = Color(0xFF91FFFF);

  static const Color error700 = Color(0xffD8281E);
  static const Color BLUE_TEXT = Color(0xFF0A7AFF);
  static const Color RED_CALENDAR = Color(0xFFF5233C);
  static const Color TRANSPARENT = Color(0x00000000);
  static const Color GREY_TOP_TAB_BAR = Color(0xFFBEC1C9);
  static const Color GREY_F0F4FA = Color(0xFFF0F4FA);

  static const Color gray = Color(0xffA8A8A8);
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
  static const Color ORANGE_TRANS = Color(0xFFF58216);
  static const Color ORANGE_DARK = Color(0xFFff5c01);
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
  static const Color BLUE_MB = Color(0xFF141CD6);
  static const Color RED_MB = Color(0xFFF4272A);
  static const Color BG_BLUE = Color(0xFF3048A1);
  static const secondary400 = Color(0xff464F77);
  static const greyF0F0F0 = Color(0xffF0F0F0);
  static const grey979797 = Color(0xff979797);
  static const greyF1F2F5 = Color(0xffF1F2F5);
  static const grey989EBE = Color(0xff989EBE);
  static const Color GREY_DADADA = Color(0xFFDADADA);
  static const Color D8ECF8 = Color(0xFFD8ECF8);
  static const Color FFEAD9 = Color(0xFFFFEAD9);
  static const Color F5C9D1 = Color(0xFFF5C9D1);

  //THEME NAME
  static const String THEME_LIGHT = 'LIGHT';
  static const String THEME_DARK = 'DARK';
  static const String THEME_SYSTEM = 'SYSTEM';

  static BoxDecoration cardDecoration(BuildContext context, {Color? color}) {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color ?? Theme.of(context).cardColor);
  }
}

class GradientColor {
  LinearGradient disableLinear = const LinearGradient(
    colors: [
      AppColor.BLUE_BGR,
      AppColor.BLUE_BGR,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
    LinearGradient disableTextLinear = const LinearGradient(
    colors: [
      AppColor.BLACK,
      AppColor.BLACK,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient disableButtonLinear = const LinearGradient(
    colors: [
      AppColor.GREY_TEXT,
      AppColor.GREY_TEXT,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient rainbowLinear = const LinearGradient(colors: [
    Color(0xFFD8ECF8),
    Color(0xFFFFEAD9),
    Color(0xFFF5C9D1),
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);
  LinearGradient brightBlueLinear = const LinearGradient(
    colors: [
      Color(0xFF00B8F5),
      Color(0xFF0A7AFF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient chardonnayLinear = const LinearGradient(
    colors: [
      Color(0xFFFFC889),
      Color(0xFFFFDCA2),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient pastelBlueLinear = const LinearGradient(
    colors: [
      Color(0xFFA6C5FF),
      Color(0xFFC5CDFF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient thistleLinear = const LinearGradient(
    colors: [
      Color(0xFFCDB3D4),
      Color(0xFFF7C1D4),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient lightYellow = const LinearGradient(
    colors: [
      Color(0xFFFCE9D9),
      Color(0xFFFCF9DF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient oysterPinkLinear = const LinearGradient(
    colors: [
      Color(0xFFF5CEC7),
      Color(0xFFFFD7BF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient skyBlueLinear = const LinearGradient(
    colors: [
      Color(0xFFBFF6FF),
      Color(0xFFFFDBE7),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient lightLilacLinear = const LinearGradient(
    colors: [
      Color(0xFFF1C9FF),
      Color(0xFFFFB5AC),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient seashellLinear = const LinearGradient(
    colors: [
      Color(0xFFF0F0F0),
      Color(0xFFCDCDCD),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  LinearGradient columbiaBlueLinear = const LinearGradient(
    colors: [
      Color(0xFF91E2FF),
      Color(0xFF91FFFF),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient cyanLinear = const LinearGradient(
    colors: [
      Color(0xFFB4FFEE),
      Color(0xFFEDFF96),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  LinearGradient lilyLinear = const LinearGradient(
    colors: [
      AppColor.BLUE_E1EFFF,
      AppColor.BLUE_E5F9FF,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient aiTextColor = const LinearGradient(
    colors: [
      Color(0xFF458BF8),
      Color(0xFFFF8021),
      Color(0xFFFF3751),
      Color(0xFFC958DB),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  LinearGradient lightMintLinear = const LinearGradient(
    colors: [
      Color(0xFFBAFFBF),
      Color(0xFFCFF4D2),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  LinearGradient suggestLinear = const LinearGradient(colors: [
    Color(0xFFD8ECF8),
    Color(0xFFFFEAD9),
    Color(0xFFF5C9D1),
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  LinearGradient vietQrPro = const LinearGradient(colors: [
    Color(0xFFE5CCA7),
    Color(0xFF736052),
  ], begin: Alignment.bottomLeft, end: Alignment.topRight);

  LinearGradient viet_qr = const LinearGradient(
    colors: [
      AppColor.WHITE,
      AppColor.GREY_F0F4FA,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class VietQRTheme {
  static AppColor appColor = AppColor();
  static GradientColor gradientColor = GradientColor();
}

//theme data
class DefaultThemeData {
  final BuildContext context;

  const DefaultThemeData({required this.context});

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColor.BLACK,
      colorScheme: const ColorScheme.dark(primary: AppColor.GREEN),
      canvasColor: AppColor.GREY_HIGHLIGHT,
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColor.GREY_VIEW,
      ),
      primaryColor: AppColor.BLACK,
      // accentColor: AppColor.GREY_LIGHT,
      hoverColor: AppColor.TRANSPARENT,
      // toggleableActiveColor: AppColor.BLACK_LIGHT,
      focusColor: AppColor.BLUE_TEXT,
      cardColor: AppColor.BLACK_BUTTON,
      shadowColor: AppColor.BLACK_LIGHT,
      hintColor: AppColor.WHITE,
      indicatorColor: AppColor.LIGHT_PINK,
      splashColor: AppColor.TRANSPARENT,
      highlightColor: AppColor.TRANSPARENT,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColor.WHITE,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.TRANSPARENT,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        fillColor: AppColor.WHITE,
      ),
    );
  }

  //use
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColor.GREY_BG,
      colorScheme: const ColorScheme.light(primary: AppColor.BLUE_TEXT),
      canvasColor: AppColor.GREY_BG,
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColor.GREY_VIEW,
      ),
      primaryColor: AppColor.WHITE,
      hoverColor: AppColor.TRANSPARENT,
      // toggleableActiveColor: AppColor.WHITE,
      focusColor: AppColor.BLUE_MB,
      // accentColor: AppColor.GREY_TEXT,
      cardColor: AppColor.WHITE,
      shadowColor: AppColor.BLACK_LIGHT,
      indicatorColor: AppColor.DARK_PINK,
      hintColor: AppColor.BLACK,
      splashColor: AppColor.TRANSPARENT,
      highlightColor: AppColor.TRANSPARENT,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColor.BLACK,
          ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        elevation: 0,
        backgroundColor: AppColor.TRANSPARENT,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: AppColor.TRANSPARENT,
            width: 1.0,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          // borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: AppColor.GREY_DADADA,
            width: 1.0,
          ),
        ),
        // border: UnderlineInputBorder(
        //   borderRadius: BorderRadius.circular(5),
        //   borderSide: const BorderSide(
        //     color: AppColor.TRANSPARENT,
        //     width: 1.0,
        //   ),
        // ),
        disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: AppColor.TRANSPARENT,
            width: 1.0,
          ),
        ),
        fillColor: AppColor.WHITE,
      ),
    );
  }
}
