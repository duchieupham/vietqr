import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.index,
    this.activeIcon,
    this.icon, {
    super.key,
    this.onTap,
    this.color = AppColor.GREY_LIGHT,
    this.activeColor = AppColor.BLUE_TEXT,
    this.isActive = false,
  });
  final int index;
  final String icon;
  final String activeIcon;
  final Color color;
  final Color activeColor;
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
                  ? XImage(
                      imagePath: icon,
                      width: 40,
                      height: 40,
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColor.WHITE,
                        gradient: isActive
                            ? VietQRTheme.gradientColor.lilyLinear
                            : null,
                      ),
                      child: Center(
                        child: XImage(
                          imagePath: isActive ? activeIcon : icon,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              // const SizedBox(height: 4),
              // Text(
              //   text,
              //   style: TextStyle(
              //       fontSize: 9,
              //       fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              //       color: AppColor.WHITE),
              // )
            ],
          )),
    );
  }
}
