import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.text,
    this.index,
    this.activeIcon,
    this.icon, {
    this.onTap,
    this.color = AppColor.GREY_LIGHT,
    this.activeColor = AppColor.BLUE_TEXT,
    this.isActive = false,
    this.isNotified = false,
  });
  final String text;
  final int index;
  final String icon;
  final String activeIcon;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          padding: const EdgeInsets.all(7),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(32),
          //   color: bottomBarColor,
          //   // boxShadow: [
          //   //   if (isActive)
          //   //     BoxShadow(
          //   //       color: shadowColor.withOpacity(0.2),
          //   //       spreadRadius: 2,
          //   //       blurRadius: 2,
          //   //       offset: Offset(0, 0), // changes position of shadow
          //   //     ),
          //   // ],
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              index == 2
                  ? Image.asset(
                      icon,
                      width: 35,
                      height: 35,
                    )
                  : Image.asset(
                      isActive ? activeIcon : icon,
                      color: isActive ? activeColor : color,
                      width: 35,
                      height: 35,
                    ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? AppColor.BLUE_TEXT : AppColor.BLACK),
              )
            ],
          )),
    );
  }
}
