import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class PinCodeInput extends StatelessWidget {
  const PinCodeInput({
    Key? key,
    this.onChanged,
    this.onCompleted,
    this.controller,
    this.obscureText = false,
    this.themeKey = false,
    this.focusNode,
    this.clBorderErr,
    this.error = false,
    this.autoFocus = false,
    this.textStyle,
    this.length,
  }) : super(key: key);

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final TextEditingController? controller;
  final bool obscureText;
  final bool themeKey;
  final FocusNode? focusNode;
  final Color? clBorderErr;
  final bool error;
  final bool autoFocus;
  final TextStyle? textStyle;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: length ?? 6,
      autoFocus: autoFocus,
      focusNode: focusNode,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: TextInputType.number,
      // inputFormatters: [TextInputMask(mask: '999999')],
      enableActiveFill: true,
      controller: controller,
      onChanged: onChanged != null ? onChanged! : _onChanged,
      cursorColor: cursorColor,
      scrollPadding: EdgeInsets.zero,
      obscuringCharacter: '⬤',
      textStyle: textStyle ?? _textStyle,
      backgroundColor: Colors.transparent,
      cursorHeight: 18,
      showCursor: true,
      autoDisposeControllers: false,
      enablePinAutofill: true,
      pinTheme: PinTheme(
        borderWidth: borderWidth,
        shape: shape,
        fieldHeight: size,
        fieldOuterPadding: EdgeInsets.zero,
        fieldWidth: size,
        activeColor: clBorderErr ?? activeColor,
        borderRadius: BorderRadius.circular(5),
        activeFillColor: activeFillColor,
        selectedColor: activeColor,
        errorBorderColor: AppColor.GREY_444B56,
        inactiveFillColor: inactiveFillColor,
        selectedFillColor: activeFillColor,
        inactiveColor: inactiveColor,
        disabledColor: AppColor.RED_EC1010,
      ),
      onCompleted: onCompleted,
    );
  }

  TextStyle get _textStyle {
    if (obscureText) {
      return Styles.copyStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );
    }

    if (error) {
      return Styles.copyStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColor.error700,
      );
    }
    return Styles.copyStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  Color get activeColor {
    return AppColor.BLUE_TEXT;
  }

  Color get inactiveColor {
    return AppColor.secondary400;
  }

//border

  double get borderWidth {
    if (themeKey) {
      return borderWidthDark;
    }
    return borderWidthLight;
  }

  double get borderWidthDark {
    if (obscureText) {
      return 1;
    }
    return 1;
  }

  double get borderWidthLight {
    if (obscureText) {
      return 1;
    }
    return 1;
  }

// Size

  double get size {
    if (themeKey) {
      return sizeDark;
    }
    return sizeLight;
  }

  double get sizeDark {
    if (obscureText) {
      return 40;
    }
    return 40;
  }

  double get sizeLight {
    if (obscureText) {
      return 40;
    }
    return 40;
  }

//màu ô input khi  chọn
  Color get activeFillColor {
    return Colors.transparent;
  }

//màu border khi chưa chọn

//màu ô input khi chưa chọn
  Color get inactiveFillColor {
    return Colors.transparent;
  }

//màu border khi chọn

  Color get cursorColor {
    return Colors.transparent;
  }

  PinCodeFieldShape get shape {
    if (themeKey) {
      return shapeDarkMode;
    }
    return shapeLightMode;
  }

  PinCodeFieldShape get shapeLightMode {
    return PinCodeFieldShape.box;
  }

  PinCodeFieldShape get shapeDarkMode {
    return PinCodeFieldShape.circle;
  }

  void _onChanged(String value) {}
}
