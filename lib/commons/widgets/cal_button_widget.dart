import 'package:flutter/material.dart';

class CalButtonWidget extends StatelessWidget {
  //size = width = height;
  final double size;
  final double? height;
  final String value;
  final VoidCallback function;
  final Color? color;
  final Color textColor;
  final IconData? icon;

  const CalButtonWidget({
    super.key,
    required this.size,
    this.height,
    required this.value,
    required this.function,
    this.color,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: size,
        height: (height != null) ? height : size * 3 / 4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: (color != null)
              ? color
              : Theme.of(context).buttonTheme.getFillColor(MaterialButton(
                    onPressed: () {},
                  )),
          borderRadius: BorderRadius.circular(10),
        ),
        child: (icon != null)
            ? Icon(
                icon,
                size: size / 3.5,
                color: textColor,
              )
            : Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: size / 3.5,
                ),
              ),
      ),
    );
  }
}
