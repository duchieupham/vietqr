import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class ScrollToTopButton extends StatefulWidget {
  final Function() onPressed;
  final double? bottom;
  final ValueNotifier<bool> notifier;
  const ScrollToTopButton(
      {super.key,
      required this.onPressed,
      required this.notifier,
      this.bottom});

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.notifier,
      builder: (context, value, child) {
        if (value == false) {
          return const SizedBox.shrink();
        }
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 50,
          height: 50,
          margin: EdgeInsets.only(bottom: widget.bottom ?? 40, right: 5),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 4,
            onPressed: widget.onPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              // side: BorderSide(color: Colors.red),
            ),
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const XImage(
                imagePath: 'assets/images/ic-arrow-upward-black.png',
              ),
            ),
          ),
        );
      },
    );
  }
}
