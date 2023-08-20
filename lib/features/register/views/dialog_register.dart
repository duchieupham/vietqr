import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';

class DialogRegister extends StatefulWidget {
  final TextEditingController passController;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;

  const DialogRegister(
      {super.key, this.onChanged, this.onTap, required this.passController});

  @override
  State<DialogRegister> createState() => _DialogRegisterState();
}

class _DialogRegisterState extends State<DialogRegister> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.WHITE,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            const DefaultTextStyle(
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK),
              child: Text('Xác nhận lại mật khẩu'),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 40,
                child: PinCodeInput(
                  autoFocus: true,
                  obscureText: true,
                  onChanged: (value) {
                    widget.onChanged!(value);
                    if (value.isNotEmpty) {
                      if (value == widget.passController.text) {
                        setState(() {
                          isCheck = false;
                        });
                      } else {
                        setState(() {
                          isCheck = true;
                        });
                      }
                    } else {
                      setState(() {
                        isCheck = true;
                      });
                    }
                  },
                ),
              ),
            ),
            Visibility(
              visible: isCheck,
              child: const Padding(
                padding: EdgeInsets.only(left: 10, top: 5, right: 30),
                child: Text(
                  'Xác nhận Mật khẩu không trùng khớp.',
                  style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                ),
              ),
            ),
            const Spacer(),
            MButtonWidget(
              colorEnableBgr: AppColor.BLUE_TEXT,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              isEnable: true,
              title: 'Đăng nhập',
              onTap: widget.onTap,
            ),
            const SizedBox(height: 10),
            MButtonWidget(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              colorEnableBgr: AppColor.GREY_F1F2F5,
              colorEnableText: AppColor.BLACK,
              isEnable: true,
              title: 'Thoát',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
