import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class DotWidget extends StatelessWidget {
  final bool isSelected;

  const DotWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (isSelected) ? 20 : 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: (isSelected)
            ? Border.all(color: DefaultTheme.GREY_LIGHT, width: 0.5)
            : null,
        color: (isSelected) ? DefaultTheme.WHITE : DefaultTheme.GREY_LIGHT,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
