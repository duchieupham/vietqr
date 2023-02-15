import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool check;
  final double size;
  final VoidCallback function;

  const CheckBoxWidget({
    Key? key,
    required this.check,
    required this.size,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Image.asset(
        (check)
            ? 'assets/images/ic-checked.png'
            : 'assets/images/ic-uncheck.png',
        color: DefaultTheme.GREEN,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
