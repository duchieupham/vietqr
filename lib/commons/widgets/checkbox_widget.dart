import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool check;
  final double size;
  final VoidCallback function;
  final Color? color;

  const CheckBoxWidget({
    super.key,
    required this.check,
    required this.size,
    required this.function,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Image.asset(
        (check)
            ? 'assets/images/ic-checked.png'
            : 'assets/images/ic-uncheck.png',
        color: color ?? AppColor.BLUE_TEXT,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
