import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/widgets/pin_code_input.dart';

import '../../../../commons/constants/configurations/numeral.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/pin_widget_register.dart';
import '../../../../services/providers/pin_provider.dart';
import '../../../../services/providers/register_provider.dart';

class FormPassword extends StatefulWidget {
  bool isFocus;
  FormPassword({
    super.key,
    required this.isFocus,
  });

  @override
  State<FormPassword> createState() => _FormPasswordState();
}

class _FormPasswordState extends State<FormPassword> {
  final repassFocus = FocusNode();
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    Provider.of<RegisterProvider>(context, listen: false)
        .passwordController
        .text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Thiết lập ',
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'mật khẩu ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(
                            Rect.fromLTWH(
                                0, 0, 200, 40), // Adjust size as needed
                          ),
                      ),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'cho tài khoản ${provider.phoneNoController.text}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 40),
                child: Focus(
                  onFocusChange: (value) {
                    setState(() {
                      widget.isFocus = value;
                    });
                  },
                  child: PinCodeInput(
                    obscureText: true,
                    // controller: provider.passwordController,
                    autoFocus: widget.isFocus,
                    focusNode: repassFocus,
                    onChanged: (text) {},
                    onCompleted: (value) {
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
              // Focus(
              //   onFocusChange: (value) {
              //     setState(() {
              //       widget.isFocus = value;
              //     });
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 50,
              //     margin: const EdgeInsets.only(left: 20, right: 20),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(50),
              //         border: Border.all(
              //             color: widget.isFocus
              //                 ? AppColor.BLUE_TEXT
              //                 : AppColor.GREY_TEXT,
              //             width: 0.5)),
              //     child: Center(
              //       child: PinWidgetRegister(
              //         width: MediaQuery.of(context).size.width,
              //         pinSize: 15,
              //         pinLength: Numeral.DEFAULT_PIN_LENGTH,
              //         focusNode: repassFocus,
              //         autoFocus: widget.isFocus,
              //         onDone: (value) {
              //           provider.updatePassword(value);
              //           if (value.length == 6) {
              //             repassFocus.requestFocus();
              //           }
              //           if (provider.isEnableButtonPassword()) {
              //             Provider.of<PinProvider>(context, listen: false)
              //                 .reset();
              //             provider.updatePage(3);
              //             pageController.animateToPage(3,
              //                 duration: const Duration(milliseconds: 300),
              //                 curve: Curves.ease);
              //           }
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              // Container(
              //   alignment: Alignment.centerRight,
              //   padding: const EdgeInsets.only(top: 30, right: 20),
              //   child: const Column(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Text(
              //         'Bao gồm 6 ký tự số.',
              //         style: TextStyle(color: AppColor.BLACK, fontSize: 15),
              //       ),
              //       Text(
              //         'Không bao gồm chữ và ký tự đặc biệt.',
              //         style: TextStyle(color: AppColor.BLACK, fontSize: 15),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
