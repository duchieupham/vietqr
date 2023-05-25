import 'package:flutter/material.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';

class PrintingView extends StatelessWidget {
  const PrintingView({super.key});

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
            'assets/images/ic-printer.png',
          ),
        ),
        const Text(
          'Đang in...',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Text(
          'Nếu không thể in được, vui lòng kiểm tra xem Bluetooth đã được kết nối và thử lại việc in.',
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        ButtonIconWidget(
          width: width - 40,
          height: 40,
          icon: Icons.cancel_rounded,
          title: 'Huỷ',
          function: () {
            Navigator.pop(context);
          },
          bgColor: Theme.of(context).canvasColor,
          textColor: Theme.of(context).hintColor,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
      ],
    );
  }
}
