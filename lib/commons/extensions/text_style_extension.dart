import 'package:flutter/material.dart';

import '../constants/configurations/theme.dart';

extension ColorExtension on TextStyle {
  TextStyle get textColor => copyWith(color: AppColor.BLACK_TEXT);
  TextStyle get blueText => copyWith(color: AppColor.BLUE_TEXT);
}

extension MyFontWeight on TextStyle {
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);

  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);

  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);

  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);

  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);

  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
}

extension MyFontStyle on TextStyle {
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
}

extension MyFontSize on TextStyle {
  TextStyle s([double size = 14]) => copyWith(fontSize: size);
  //
  TextStyle get s8 => copyWith(fontSize: 8);
  TextStyle get s10 => copyWith(fontSize: 10);
  TextStyle get s11 => copyWith(fontSize: 11);
  TextStyle get s12 => copyWith(fontSize: 12);
  TextStyle get s14 => copyWith(fontSize: 14);
  TextStyle get s16 => copyWith(fontSize: 16);
  TextStyle get s18 => copyWith(fontSize: 18);
  TextStyle get s20 => copyWith(fontSize: 20);
  TextStyle get s32 => copyWith(fontSize: 32);
}

class AppFont {
  static TextStyle get t => const TextStyle(
    color: AppColor.BLACK_TEXT,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    // fontFamily: FontFamily.beVN,
  );
}