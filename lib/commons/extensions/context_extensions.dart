import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/screen_size.dart';

extension ContextExtensions on BuildContext {
  ScreenSize get getSize {
    final deviceWidth = device.shortestSide;
    if (deviceWidth > 900) return ScreenSize.extraLarge;
    if (deviceWidth > 600) return ScreenSize.large;
    if (deviceWidth > 300) return ScreenSize.normal;
    return ScreenSize.small;
  }

  Orientation get deviceOrientation => MediaQuery.of(this).orientation;

  TargetPlatform get platform => Theme.of(this).platform;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;

  void get hideKeyboard => FocusScope.of(this).unfocus();

  Size get device => MediaQuery.of(this).size;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ThemeData get theme => Theme.of(this);

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;
}
