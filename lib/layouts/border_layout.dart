import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class BorderLayout extends StatelessWidget {
  final double width;
  final bool isError;
  final Widget child;
  final EdgeInsets? padding;
  final double? height;

  const BorderLayout({
    super.key,
    required this.width,
    required this.isError,
    required this.child,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: (padding != null) ? padding : null,
      decoration: BoxDecoration(
        border: Border.all(
            color: (isError)
                ? AppColor.RED_TEXT
                : AppColor.GREY_TOP_TAB_BAR,
            width: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}
