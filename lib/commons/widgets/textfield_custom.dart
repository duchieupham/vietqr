import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';

class TextFieldCustom extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChange;
  final VoidCallback? onEditingComplete;
  final ValueChanged<Object>? onSubmitted;
  final TextInputAction? keyboardAction;
  final TextInputType inputType;
  final bool isObscureText;
  final double? fontSize;
  final TextfieldType? textFieldType;
  final String? title;
  final bool? autoFocus;
  final bool? enable;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final TextAlign? textAlign;
  final Function(PointerDownEvent)? onTapOutside;
  final bool isShowToast;
  final TextStyle? errorStyle;
  final Function(String? error)? showToast;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  //Border textfield
  final bool isRequired;
  final Color? fillColor;

  const TextFieldCustom({
    Key? key,
    required this.hintText,
    this.controller,
    this.fillColor,
    required this.keyboardAction,
    required this.onChange,
    required this.inputType,
    required this.isObscureText,
    this.fontSize,
    this.textFieldType,
    this.title,
    this.autoFocus,
    this.focusNode,
    this.maxLines,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLength,
    this.textAlign,
    this.onTapOutside,
    this.enable,
    this.isShowToast = false,
    this.errorStyle,
    this.showToast,
    this.validator,
    this.inputFormatter,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<TextFieldCustom> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldCustom> {
  String? _msgError;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget textFiledTypeLabel = TextFormField(
      obscureText: widget.isObscureText,
      controller: _editingController,
      onChanged: widget.onChange,
      textAlign:
          (widget.textAlign != null) ? widget.textAlign! : TextAlign.left,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.inputFormatter,
      onTapOutside: widget.onTapOutside,
      maxLength: widget.maxLength,
      enabled: widget.enable,
      autofocus: widget.autoFocus ?? false,
      focusNode: widget.focusNode,
      keyboardType: widget.inputType,
      maxLines: (widget.maxLines == null) ? 1 : widget.maxLines,
      textInputAction: widget.keyboardAction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: (widget.fontSize != null) ? widget.fontSize : 14,
          color: (widget.title != null)
              ? AppColor.GREY_TEXT
              : Theme.of(context).hintColor,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        fillColor: widget.fillColor ?? AppColor.WHITE,
        filled: true,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.textFieldType != null &&
            widget.textFieldType == TextfieldType.LABEL)
          Row(
            children: [
              SizedBox(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(
                    fontSize: (widget.fontSize != null) ? widget.fontSize : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (widget.isRequired)
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: (widget.fontSize != null) ? widget.fontSize : 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.RED_EC1010,
                  ),
                ),
            ],
          ),
        const SizedBox(height: 8),
        Container(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFiledTypeLabel,
              if (_msgError != null && !widget.isShowToast)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    _msgError!,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: widget.errorStyle ?? Styles.errorStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool checkValidate() {
    if (widget.validator != null) {
      setState(() {
        _msgError = widget.validator!(_editingController.text);
        if (widget.isShowToast && _msgError != null) {
          widget.showToast!(_msgError);
        }
      });
    }
    return _msgError == null;
  }

  void resetValid() {
    setState(() {
      _msgError = null;
    });
  }

  void onTap() {
    if (_msgError != null) {
      setState(() {
        _msgError = null;
      });
    }
  }

  void showError(String? value) {
    setState(() {
      _msgError = value;
    });
  }

  TextEditingController get _editingController =>
      widget.controller ?? _controller;

  String get text => _editingController.text;
}
