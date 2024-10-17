import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/circle_loading_animation_widget.dart';

class LoadingAccountBankNameWidget extends StatelessWidget {
  const LoadingAccountBankNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chủ tài khoản*',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
              // color: Colors.blue,
              color: AppColor.WHITE,
              border: Border(
                bottom: BorderSide(color: AppColor.GREY_DADADA),
              )),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            height: 30,
            width: 30,
            child: const CircleLoadingAnimationWidget(
              size: 30,
              color: AppColor.GREY_TEXT,
            ),
          ),
        ),
      ],
    );
  }
}
