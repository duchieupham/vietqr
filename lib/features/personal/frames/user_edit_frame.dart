import 'package:flutter/material.dart';

class UserEditFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget mobileChildren;

  const UserEditFrame({
    super.key,
    required this.width,
    required this.height,
    required this.mobileChildren,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.only(top: 10),
      child: mobileChildren,
    );
  }
}
