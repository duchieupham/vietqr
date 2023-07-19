import 'package:flutter/material.dart';

class ButtonIconWidget extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final VoidCallback function;
  final Color bgColor;
  final Color textColor;
  final double? height;
  final double? textSize, iconSize;
  final bool? autoFocus;
  final double? borderRadius;
  final FocusNode? focusNode;
  final Alignment? alignment;
  final EdgeInsets contentPadding;
  final bool enableShadow;
  final String pathIcon;

  const ButtonIconWidget({
    super.key,
    required this.width,
    this.icon = Icons.add,
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
    this.iconSize,
    this.pathIcon = '',
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    this.enableShadow = false,
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
        padding: contentPadding,
        alignment: alignment,
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: enableShadow
              ? [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ]
              : null,
          borderRadius:
              BorderRadius.circular((borderRadius != null) ? borderRadius! : 5),
        ),
        child: Row(
          mainAxisAlignment: (alignment == Alignment.centerLeft)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (pathIcon.isNotEmpty)
              Image.asset(
                pathIcon,
                width: iconSize,
              )
            else
              Icon(
                icon,
                color: textColor,
                size: iconSize ?? 15,
              ),
            if (title.isNotEmpty) ...[
              if (pathIcon.isEmpty)
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
