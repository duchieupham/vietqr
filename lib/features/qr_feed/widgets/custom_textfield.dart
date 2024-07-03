import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final Color borderColor;
  final Color hintTextColor;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? textInputType;
  final int? maxLines;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;
  final bool isActive;
  final FocusNode? focusNode;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.borderColor,
    required this.hintTextColor,
    required this.onClear,
    required this.onChanged,
    this.focusNode,
    this.inputFormatter,
    this.textInputType,
    this.maxLines,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        MTextFieldCustom(
            onTap: onTap,
            controller: controller,
            focusNode: focusNode,
            inputFormatter: inputFormatter,
            hintText: hintText,
            // enableBorder: UnderlineInputBorder(),
            focusBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.BLUE_TEXT)),
            contentPadding: EdgeInsets.zero,
            suffixIcon: InkWell(
              onTap: onClear,
              child: const Icon(
                Icons.clear,
                size: 20,
                color: AppColor.GREY_DADADA,
              ),
            ),
            keyboardAction: TextInputAction.next,
            onChange: onChanged,
            inputType: textInputType ?? TextInputType.multiline,
            isObscureText: false)
      ],
    );
  }
}
