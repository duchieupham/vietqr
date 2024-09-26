import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class ButtonNavigatePageWidget extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback function;
  final bool isPrevious;

  const ButtonNavigatePageWidget({
    super.key,
    required this.width,
    required this.height,
    required this.function,
    required this.isPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: (isPrevious) ? 'Trở về' : 'Tiếp theo',
      child: InkWell(
        onTap: function,
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor.withOpacity(0.9),
            // border: Border.all(
            //     color: DefaultTheme.GREY_TEXT.withOpacity(0.6), width: 0.5),
            borderRadius: BorderRadius.horizontal(
              left: (isPrevious)
                  ? const Radius.circular(5)
                  : const Radius.circular(2),
              right: (!isPrevious)
                  ? const Radius.circular(5)
                  : const Radius.circular(2),
            ),
          ),
          child: Icon(
            (isPrevious)
                ? Icons.arrow_back_ios_rounded
                : Icons.arrow_forward_ios_rounded,
            color: AppColor.GREY_TEXT,
            size: 20,
          ),
        ),
      ),
    );
  }
}
