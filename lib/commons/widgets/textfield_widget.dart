import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';

class TextFieldWidget extends StatelessWidget {
  final double width;
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
  final String? title;
  final double? titleWidth;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;

  const TextFieldWidget({
    Key? key,
    required this.width,
    required this.hintText,
    required this.controller,
    required this.keyboardAction,
    required this.onChange,
    required this.inputType,
    required this.isObscureText,
    this.fontSize,
    this.textfieldType,
    this.title,
    this.titleWidth,
    this.autoFocus,
    this.focusNode,
    this.maxLines,
    this.onEdittingComplete,
    this.onSubmitted,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (textfieldType != null && textfieldType == TextfieldType.LABEL)
        ? Container(
            width: width,
            height: 60,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: (titleWidth != null) ? titleWidth : 80,
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: (fontSize != null) ? fontSize : 16,
                    ),
                  ),
                ),
                Flexible(
                  child: TextField(
                    obscureText: isObscureText,
                    controller: controller,
                    onChanged: onChange,
                    onEditingComplete: onEdittingComplete,
                    onSubmitted: onSubmitted,
                    maxLength: maxLength,
                    autofocus: (autoFocus != null) ? autoFocus! : false,
                    focusNode:
                        (PlatformUtils.instance.isMobileFlatform(context))
                            ? null
                            : focusNode,
                    keyboardType: inputType,
                    maxLines: (maxLines == null) ? 1 : maxLines,
                    textInputAction: keyboardAction,
                    decoration: InputDecoration(
                      hintText: hintText,
                      counterText: '',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: (fontSize != null) ? fontSize : 16,
                        color: (title != null)
                            ? DefaultTheme.GREY_TEXT
                            : Theme.of(context).hintColor,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ))
        : Container(
            width: width,
            height: 60,
            alignment: Alignment.center,
            child: TextField(
              obscureText: isObscureText,
              controller: controller,
              onChanged: onChange,
              onSubmitted: onSubmitted,
              onEditingComplete: onEdittingComplete,
              keyboardType: inputType,
              maxLines: 1,
              maxLength: maxLength,
              textInputAction: keyboardAction,
              autofocus: (autoFocus != null) ? autoFocus! : false,
              focusNode: (PlatformUtils.instance.isMobileFlatform(context))
                  ? null
                  : focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                counterText: '',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: (fontSize != null) ? fontSize : 16,
                  color: Theme.of(context).hintColor,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          );
  }
}
