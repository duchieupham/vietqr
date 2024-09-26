import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/layouts/box_layout.dart';

class LoginFrame extends StatelessWidget {
  final double width;
  final double height;
  final double? heightBox;
  final Widget widget1;
  final Widget widget2;
  final EdgeInsets? padding;

  const LoginFrame({
    super.key,
    required this.width,
    required this.height,
    required this.widget1,
    required this.widget2,
    this.padding,
    this.heightBox,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-qr.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: (PlatformUtils.instance.resizeWhen(width, 750))
            ? BoxLayout(
                width: 700,
                height: heightBox ?? 400,
                borderRadius: 5,
                enableShadow: true,
                padding: padding,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 400,
                        child: widget1,
                      ),
                    ),
                    widget2,
                  ],
                ),
              )
            : BoxLayout(
                width: width * 0.8,
                height: heightBox,
                borderRadius: 5,
                enableShadow: true,
                padding: padding,
                child: widget1,
              ),
      ),
    );
  }
}
