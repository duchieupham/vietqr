import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/constants/configurations/numeral.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/pin_widget_register.dart';
import '../../../../services/providers/pin_provider.dart';
import '../../../../services/providers/register_provider.dart';

class FormPassword extends StatefulWidget {
  bool isFocus;
  FormPassword({super.key, required this.isFocus,});

  @override
  State<FormPassword> createState() => _FormPasswordState();
}

class _FormPasswordState extends State<FormPassword> {
  final repassFocus = FocusNode();
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 30,
                  top: 50,
                  left: 20,
                ),
                width: double.infinity,
                child: Text(
                  'Tiếp theo, đặt mật khẩu\ncho số điện thoại\n${provider.phoneNoController.text}',
                  style: const TextStyle(
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
                  margin: const EdgeInsets.only(left: 20, right: 20),
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
                        provider.updatePassword(value);
                        if (value.length == 6) {
                          repassFocus.requestFocus();
                        }
                        if (provider.isEnableButtonPassword()) {
                          Provider.of<PinProvider>(context, listen: false)
                              .reset();
                          provider.updatePage(3);
                          pageController.animateToPage(3,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        }
                      },
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 30, right: 20),
                child: const Column(
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
    );
  }
}
