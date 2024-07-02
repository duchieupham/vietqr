import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.text,
    this.index,
    this.activeIcon,
    this.icon, {
    super.key,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              index == 2
                  ? Image.asset(
                      icon,
                      width: 35,
                      height: 35,
                    )
                  : Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        // color: bottomBarColor,

                        boxShadow: [
                          if (isActive)
                            BoxShadow(
                              color: AppColor.WHITE.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                        ],
                      ),
                      child: XImage(imagePath: isActive ? activeIcon : icon),
                    ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: AppColor.WHITE),
              )
            ],
          )),
    );
  }
}
