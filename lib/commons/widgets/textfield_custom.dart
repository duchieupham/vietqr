import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';

class TextFieldCustom extends StatefulWidget {
  final double width;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<Object>? onChange;
  final VoidCallback? onEditingComplete;
  final ValueChanged<Object>? onSubmitted;
  final TextInputAction? keyboardAction;
  final TextInputType inputType;
  final bool isObscureText;
  final double? fontSize;
  final TextfieldType? textFieldType;
  final String? title;
  final double? titleWidth;
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

  const TextFieldCustom({
    Key? key,
    required this.width,
    required this.hintText,
    this.controller,
    required this.keyboardAction,
    required this.onChange,
    required this.inputType,
    required this.isObscureText,
    this.fontSize,
    this.textFieldType,
    this.title,
    this.titleWidth,
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
  }) : super(key: key);

  @override
  State<TextFieldCustom> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldCustom> {
  String? _msgError;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (widget.textFieldType != null &&
            widget.textFieldType == TextfieldType.LABEL)
        ? Column(
            children: [
              Container(
                  width: widget.width,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: (widget.titleWidth != null)
                            ? widget.titleWidth
                            : 80,
                        child: Text(
                          widget.title ?? '',
                          style: TextStyle(
                            fontSize: (widget.fontSize != null)
                                ? widget.fontSize
                                : 16,
                          ),
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          obscureText: widget.isObscureText,
                          controller: _editingController,
                          onChanged: widget.onChange,
                          textAlign: (widget.textAlign != null)
                              ? widget.textAlign!
                              : TextAlign.left,
                          onEditingComplete: widget.onEditingComplete,
                          onSubmitted: widget.onSubmitted,
                          onTapOutside: widget.onTapOutside,
                          maxLength: widget.maxLength,
                          enabled: widget.enable,
                          autofocus: widget.autoFocus ?? false,
                          focusNode: widget.focusNode,
                          keyboardType: widget.inputType,
                          maxLines:
                              (widget.maxLines == null) ? 1 : widget.maxLines,
                          textInputAction: widget.keyboardAction,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            counterText: '',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: (widget.fontSize != null)
                                  ? widget.fontSize
                                  : 16,
                              color: (widget.title != null)
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
                  )),
              if (_msgError != null && !widget.isShowToast)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Text(
                    _msgError!,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: widget.errorStyle ?? Styles.errorStyle(fontSize: 12),
                  ),
                ),
            ],
          )
        : Column(
            children: [
              Container(
                width: widget.width,
                height: 60,
                alignment: Alignment.center,
                child: TextField(
                  obscureText: widget.isObscureText,
                  controller: _editingController,
                  textAlign: (widget.textAlign != null)
                      ? widget.textAlign!
                      : TextAlign.left,
                  onChanged: widget.onChange,
                  onSubmitted: widget.onSubmitted,
                  onEditingComplete: widget.onEditingComplete,
                  keyboardType: widget.inputType,
                  maxLines: 1,
                  maxLength: widget.maxLength,
                  textInputAction: widget.keyboardAction,
                  autofocus: widget.autoFocus ?? false,
                  focusNode: widget.focusNode,
                  enabled: widget.enable,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    counterText: '',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize:
                          (widget.fontSize != null) ? widget.fontSize : 16,
                      color: Theme.of(context).hintColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                ),
              ),
              if (_msgError != null && !widget.isShowToast)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Text(
                    _msgError!,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: widget.errorStyle ?? Styles.errorStyle(fontSize: 12),
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
