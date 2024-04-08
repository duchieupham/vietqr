import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../layouts/pin_code_input.dart';
import '../../../../services/providers/register_provider.dart';

class FormConfirmPassword extends StatefulWidget {
  final Function(int) onEnterIntro;

  FormConfirmPassword({
    Key? key,
    required this.onEnterIntro,
  }) : super(key: key);

  @override
  State<FormConfirmPassword> createState() => _FormConfirmPasswordState();
}

class _FormConfirmPasswordState extends State<FormConfirmPassword> {
  final repassFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        var phoneNumber = provider.phoneNumberValue;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 30,
                  top: 150,
                ),
                width: double.infinity,
                child: Text(
                  'Vui lòng xác nhận lại\nmật khẩu vừa đặt',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                width: 280,
                child: PinCodeInput(
                  autoFocus: true,
                  obscureText: true,
                  focusNode: repassFocus,
                  onChanged: (value) {
                    provider.updateConfirmPassword(value);
                  },
                ),
              ),
              Visibility(
                visible: provider.confirmPassErr,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 10, right: 40),
                  child: Text(
                    'Mật khẩu xác nhận không trùng khớp',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              Container(
                width: 350,
                height: 50,
                margin: EdgeInsets.only(top: 288),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.BLUE_TEXT),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    if (provider.isEnableButton()) {
                      widget.onEnterIntro(1);
                    } else {
                      provider.updatePhone(provider.phoneNoController.text);
                      provider.updatePassword(provider.passwordController.text);
                      provider.updateConfirmPassword(
                          provider.confirmPassController.text);
                    }
                  },
                  child: const Text(
                    'Tôi được giới thiệu đăng ký',
                    style: TextStyle(
                      color: AppColor.BLUE_TEXT,
                      fontSize: 13,
                    ),
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
