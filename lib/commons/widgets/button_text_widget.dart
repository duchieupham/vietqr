import 'package:flutter/material.dart';

class ButtonTextWidget extends StatelessWidget {
  final double width;
  final Alignment alignment;
  final String text;
  final Color textColor;
  final VoidCallback function;

  const ButtonTextWidget({
    Key? key,
    required this.width,
    required this.alignment,
    required this.text,
    required this.textColor,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: width,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        alignment: alignment,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
