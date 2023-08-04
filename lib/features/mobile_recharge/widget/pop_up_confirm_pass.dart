import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/services/providers/confirm_pass_provider.dart';

class PopupConfirmPassword extends StatelessWidget {
  final Function(String) onConfirmSuccess;
  PopupConfirmPassword({Key? key, required this.onConfirmSuccess})
      : super(key: key);

  final TextEditingController _passEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => ConfirmPassProvider(),
      child: Consumer<ConfirmPassProvider>(builder: (context, provider, child) {
        return Column(
          children: [
            const Text(
              'Xác nhận lại mật khẩu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Nhập lại mật khẩu để thực hiện nạp tiền điện thoại',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            PinCodeInput(
              obscureText: true,
              controller: _passEditingController,
              autoFocus: true,
              onChanged: provider.changePass,
              onCompleted: (value) {
                provider.requestPayment(value,
                    onConfirmSuccess: onConfirmSuccess);
              },
            ),
            if (provider.errorPass)
              const Text(
                'Mật khẩu không đúng, vui lòng thử lại',
                style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
              ),
            const SizedBox(
              height: 8,
            ),
            const Spacer(),
            MButtonWidget(
                title: 'Xác nhận',
                colorEnableText: AppColor.WHITE,
                colorEnableBgr: AppColor.BLUE_TEXT,
                margin: EdgeInsets.zero,
                isEnable: true,
                onTap: () {
                  if (provider.completedInput) {
                    provider.requestPayment(provider.pass,
                        onConfirmSuccess: onConfirmSuccess);
                  } else {
                    provider.updateErrorPass(true);
                  }
                }),
            const SizedBox(
              height: 12,
            ),
            MButtonWidget(
                title: 'Huỷ',
                colorEnableText: AppColor.BLACK,
                colorEnableBgr: AppColor.GREY_BUTTON,
                margin: EdgeInsets.zero,
                isEnable: true,
                onTap: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      }),
    );
  }
}
