import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class AssistanceInfo extends StatelessWidget {
  final bool isUpdateInfo;
  const AssistanceInfo({super.key, required this.isUpdateInfo});

  @override
  Widget build(BuildContext context) {
    return isUpdateInfo
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/logo-home.png',
                  width: 60,
                  height: 60,
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
