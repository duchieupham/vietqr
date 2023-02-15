import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/layouts/box_layout.dart';

class UserEditFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget mobileChildren;
  final Widget widget1;
  final Widget widget2;

  const UserEditFrame({
    super.key,
    required this.width,
    required this.height,
    required this.mobileChildren,
    required this.widget1,
    required this.widget2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(top: 10),
      child: (PlatformUtils.instance.resizeWhen(width, 800))
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: height,
                  child: widget1,
                ),
                BoxLayout(
                  width: 500,
                  height: height,
                  child: SingleChildScrollView(child: widget2),
                ),
              ],
            )
          : (PlatformUtils.instance.isWeb())
              ? BoxLayout(
                  width: width,
                  height: height,
                  borderRadius: 0,
                  child: ListView(
                    children: [
                      widget1,
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      widget2,
                    ],
                  ),
                )
              : mobileChildren,
    );
  }
}
