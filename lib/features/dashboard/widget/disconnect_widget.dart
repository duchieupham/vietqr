import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';

class DisconnectWidget extends StatelessWidget {
  final VoidCallback function;

  const DisconnectWidget({
    super.key,
    required this.function,
  });

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
            'assets/images/ic-disconnect.png',
          ),
        ),
        const Text(
          'Mất kết nối',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Text(
          'Vui lòng kiểm tra lại kết nối mạng, đảm bảo rằng Wifi hoặc dữ liệu di động được bật.',
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
        ButtonIconWidget(
          width: width - 40,
          height: 40,
          icon: Icons.refresh_rounded,
          title: 'Thử lại',
          function: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                Navigator.of(context).pop();
              }
            } on SocketException catch (_) {
              LOG.error('connect failed');
            }
          },
          bgColor: Theme.of(context).canvasColor,
          textColor: Theme.of(context).hintColor,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 30),
        ),
      ],
    );
  }
}
