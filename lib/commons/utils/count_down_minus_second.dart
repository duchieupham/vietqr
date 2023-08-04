import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class CountDown extends AnimatedWidget {
  CountDown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      timerText,
      style: const TextStyle(
        fontSize: 20,
        color: AppColor.BLUE_TEXT,
      ),
    );
  }
}
