import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../layouts/pin_code_input.dart';
import '../../../../services/providers/register_provider.dart';

class FormPassword extends StatelessWidget {
   FormPassword({super.key});

  final repassFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RegisterProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: 30,
                    top: 150,
                    left: 20,
                  ),
                  width: double.infinity,
                  child: Text(
                    'Tiếp theo, đặt mật khẩu\ncho số điện thoại\n${provider.phoneNoController.text}',
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
                    onChanged: (value) {
                      provider.updatePassword(value);
                      Future.delayed(const Duration(seconds: 1), () {
                        if (value.length == 6) {
                          repassFocus.requestFocus();
                        }
                      });
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 30, right: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Bao gồm 6 ký tự số.',
                        style: TextStyle(color: AppColor.BLACK, fontSize: 15),
                      ),
                      Text(
                        'Không bao gồm chữ và ký tự đặc biệt.',
                        style: TextStyle(color: AppColor.BLACK, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
