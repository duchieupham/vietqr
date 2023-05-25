import 'package:flutter/material.dart';

class ButtonIconWidget extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final VoidCallback function;
  final Color bgColor;
  final Color textColor;
  final double? height;
  final double? textSize;
  final bool? autoFocus;
  final double? borderRadius;
  final FocusNode? focusNode;
  final Alignment? alignment;

  const ButtonIconWidget({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.function,
    required this.bgColor,
    required this.textColor,
    this.height,
    this.textSize,
    this.autoFocus,
    this.borderRadius,
    this.focusNode,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      autofocus: (autoFocus != null) ? autoFocus! : false,
      focusNode: focusNode,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        alignment: alignment,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:
              BorderRadius.circular((borderRadius != null) ? borderRadius! : 5),
        ),
        child: Row(
          mainAxisAlignment: (alignment == Alignment.centerLeft)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: (textSize != null) ? textSize : 15,
            ),
            if (title.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.only(left: 5)),
              Text(
                title,
                style: TextStyle(
                  fontSize: (textSize != null) ? textSize : 15,
                  color: textColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
