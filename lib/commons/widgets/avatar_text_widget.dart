import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class AvatarTextWidget extends StatelessWidget {
  final double size;
  final String text;

  const AvatarTextWidget({
    Key? key,
    required this.size,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColor.GREY_VIEW,
            AppColor.GREY_TOP_TAB_BAR,
          ],
        ),
      ),
      child: Text(
        (text == '') ? '' : text.trim().characters.first.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size * (1 / 2),
          color: AppColor.GREY_TEXT,
        ),
      ),
    );
  }
}
