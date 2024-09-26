import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';

class MaintainWidget extends StatelessWidget {
  final Function() onRetry;

  const MaintainWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        SizedBox(
          width: width * 0.4,
          child: Image.asset(
            'assets/images/ic-maintain.png',
          ),
        ),
        const Text(
          'Hệ thống đang bảo trì',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Text(
          'Chúng tôi đang thực hiện việc bảo trì hệ thống. Vui lòng thử lại trong một vài phút.',
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        ButtonIconWidget(
          width: width - 40,
          height: 40,
          icon: Icons.refresh_rounded,
          title: 'Thử lại',
          function: (){
            onRetry();
          },
          bgColor: AppColor.BLUE_TEXT,
          textColor: AppColor.WHITE,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 30),
        ),
      ],
    );
  }
}
