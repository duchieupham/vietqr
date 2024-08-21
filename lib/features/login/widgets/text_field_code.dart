import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';

class TextFormFieldCode extends StatelessWidget {
  final double? width;
  final double? height;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<Object>? onChange;
  final VoidCallback? onEdittingComplete;
  final ValueChanged<Object>? onSubmitted;
  final TextInputAction? keyboardAction;
  final TextInputType inputType;
  final bool isObscureText;
  final double? fontSize;
  final TextfieldType? textfieldType;
  final List<TextInputFormatter>? inputFormatters;
  final String? title;
  final double? titleWidth;
  final bool autoFocus;
  final bool readOnly;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final TextAlign? textAlign;
  final Function(PointerDownEvent)? onTapOutside;

  const TextFormFieldCode({
    super.key,
    this.width,
    required this.hintText,
    required this.controller,
    required this.keyboardAction,
    required this.onChange,
    required this.inputType,
    required this.isObscureText,
    this.inputFormatters,
    this.fontSize,
    this.textfieldType,
    this.title,
    this.titleWidth,
    this.autoFocus = false,
    this.focusNode,
    this.maxLines,
    this.onEdittingComplete,
    this.onSubmitted,
    this.maxLength,
    this.textAlign,
    this.onTapOutside,
    this.readOnly = false,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      obscureText: isObscureText,
      keyboardType: inputType,
      textInputAction: keyboardAction,
      controller: controller,
      onChanged: onChange,
      autofocus: autoFocus,
      textAlign: (textAlign != null) ? textAlign! : TextAlign.left,
      onEditingComplete: onEdittingComplete,
      onSubmitted: onSubmitted,
      onTapOutside: onTapOutside,
      focusNode: focusNode,
      maxLines: (maxLines == null) ? 1 : maxLines,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        suffixIcon: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Icon(
            Icons.clear,
            color: Colors.black,
            size: 20,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        fillColor: AppColor.WHITE,
        filled: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: AppColor.GREY_TEXT,
            fontSize: 15),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
