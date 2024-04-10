import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../commons/constants/configurations/numeral.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/pin_widget_register.dart';
import '../../../../services/providers/register_provider.dart';

class FormConfirmPassword extends StatefulWidget {
  final Function(int) onEnterIntro;
  bool isFocus;

  FormConfirmPassword({
    Key? key,
    required this.onEnterIntro,
    required this.isFocus,
  }) : super(key: key);

  @override
  State<FormConfirmPassword> createState() => _FormConfirmPasswordState();
}

class _FormConfirmPasswordState extends State<FormConfirmPassword> {
  final repassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        var phoneNumber = provider.phoneNumberValue;
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50, bottom: 30, left: 20),
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
                  Focus(
                    onFocusChange: (value) {
                      setState(() {
                        widget.isFocus = value;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: widget.isFocus
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.GREY_TEXT,
                              width: 0.5)),
                      child: Center(
                        child: PinWidgetRegister(
                          width: MediaQuery.of(context).size.width,
                          pinSize: 15,
                          pinLength: Numeral.DEFAULT_PIN_LENGTH,
                          focusNode: repassFocus,
                          autoFocus: widget.isFocus,
                          onDone: (value) {
                            provider.updateConfirmPassword(value);
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: provider.confirmPassErr,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 10, right: 20),
                      child: Text(
                        'Mật khẩu xác nhận không trùng khớp',
                        style:
                            TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
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
                child: Container(
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.BLUE_TEXT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
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
