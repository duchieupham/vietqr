import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class IconNavigateNextWidget extends StatelessWidget {
  const IconNavigateNextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Icon(
        Icons.navigate_next_rounded,
        color: AppColor.GREY_TEXT,
        size: 20,
      ),
    );
  }
}
