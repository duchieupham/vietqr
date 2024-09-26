import 'package:flutter/material.dart';

class HeaderButtonWidget extends StatelessWidget {
  final String title;
  final Widget button;

  const HeaderButtonWidget({
    super.key,
    required this.title,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        button,
      ]),
    );
  }
}
