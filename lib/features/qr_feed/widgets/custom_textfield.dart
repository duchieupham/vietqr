import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? textInputType;
  final int? maxLines;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;
  final bool isActive;
  final bool expands;
  final double height;

  final FocusNode? focusNode;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.onClear,
    required this.onChanged,
    this.focusNode,
    this.inputFormatter,
    this.textInputType,
    this.maxLines,
    required this.isActive,
    this.onTap,
    this.expands = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    bool isClear = false;
    if (controller.text.isNotEmpty) {
      isClear = true;
    } else {
      isClear = false;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          // height: height,
          child: MTextFieldCustom(
              expands: expands,
              maxLines: maxLines,
              enable: isActive,
              onTap: onTap,
              controller: controller,
              focusNode: focusNode,
              inputFormatter: inputFormatter,
              hintText: hintText,
              // enableBorder: UnderlineInputBorder(),
              focusBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.BLUE_TEXT)),
              contentPadding: EdgeInsets.zero,
              suffixIcon: isClear
                  ? InkWell(
                      onTap: onClear,
                      child: const Icon(
                        Icons.clear,
                        size: 20,
                        color: AppColor.GREY_DADADA,
                      ),
                    )
                  : const SizedBox.shrink(),
              keyboardAction: TextInputAction.next,
              onChange: onChanged,
              inputType: textInputType ?? TextInputType.multiline,
              isObscureText: false),
        )
      ],
    );
  }
}
