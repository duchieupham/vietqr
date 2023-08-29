import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/pin_code_input.dart';

import '../../../../commons/widgets/phone_widget.dart';
import '../../../../services/providers/register_provider.dart';

class FormAccount extends StatelessWidget {
  final TextEditingController phoneController;

  const FormAccount({Key? key, required this.phoneController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Số điện thoại*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Số điện thoại được dùng để đăng nhập vào hệ thống VietQR Vn',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.BLACK,
                  ),
                ),
              ),
              PhoneWidget(
                onChanged: provider.updatePhone,
                phoneController: phoneController,
              ),
              Visibility(
                visible: provider.phoneErr,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5, top: 5, right: 30),
                  child: Text(
                    'Số điện thoại không đúng định dạng.',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Đặt mật khẩu*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Mật khẩu có độ dài 6 ký tự số, không bao gồm chữ và ký tự đặc biệt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: PinCodeInput(
                  autoFocus: true,
                  obscureText: true,
                  onChanged: (value) {
                    provider.updatePassword(value);
                  },
                ),
              ),
              Visibility(
                visible: provider.passwordErr,
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Mật khẩu bao gồm 6 số.',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Xác nhận lại mật khẩu*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Nhập lại mật khẩu ở trên để xác nhận',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: PinCodeInput(
                  autoFocus: true,
                  obscureText: true,
                  onChanged: (value) {
                    provider.updateConfirmPassword(value);
                  },
                ),
              ),
              Visibility(
                visible: provider.confirmPassErr,
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Mật khẩu không trùng nhau',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
