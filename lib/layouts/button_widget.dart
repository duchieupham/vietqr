import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class MButtonWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;

  const MButtonWidget({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.BLUE_TEXT,
            ),
            child: Text(
              title,
              style: const TextStyle(color: AppColor.WHITE, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
