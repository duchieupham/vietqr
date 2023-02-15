import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double width;
  //height default 50
  final String text;
  final Color textColor;
  final Color bgColor;
  final VoidCallback function;
  final double? height;
  final double? borderRadius;
  final bool? autoFocus;

  const ButtonWidget({
    Key? key,
    required this.width,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.function,
    this.height,
    this.borderRadius,
    this.autoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      autofocus: (autoFocus != null) ? autoFocus! : false,
      child: Container(
        width: width,
        height: (height != null) ? height : 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              (borderRadius != null) ? borderRadius! : 15),
          color: bgColor,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
