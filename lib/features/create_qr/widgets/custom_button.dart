import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Color? iconColor;
  final String text;
  final IconData? icon;
  final VoidCallback buttonTapped;
  final TextStyle? style;
  final bool isIcon;

  const CustomButton({
    Key? key,
    required this.color,
    required this.textColor,
    this.iconColor,
    required this.text,
    required this.buttonTapped,
    this.style,
    this.icon,
    this.isIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: !isIcon
              ? Text(
                  text,
                  style: style ??
                      TextStyle(
                        color: textColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                )
              : Icon(icon, size: 28, color: iconColor ?? Colors.white),
        ),
      ),
    );
  }
}
