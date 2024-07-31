import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/phone_widget.dart';
import '../../../../services/providers/register_provider.dart';

class FormPhone extends StatefulWidget {
  final TextEditingController phoneController;
  final PageController pageController;
  final bool isFocus;
  final Function(int) onEnterIntro;

  const FormPhone(
      {super.key,
      required this.pageController,
      required this.phoneController,
      required this.isFocus,
      required this.onEnterIntro});

  @override
  State<FormPhone> createState() => _FormPhoneState();
}

class _FormPhoneState extends State<FormPhone> {
  @override
  void initState() {
    super.initState();
    widget.phoneController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nhập ',
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'số điện thoại ',
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
                'để đăng ký tài khoản VietQR',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // PhoneWidget(
              //   phoneController: widget.phoneController,
              //   onChanged: provider.updatePhone,
              //   autoFocus: false,
              // ),
              PhoneWidget(
                onChanged: provider.updatePhone,
                onSubmit: (value) {
                  String text = value..replaceAll(' ', '');
                  if (text.length == 10) {
                    provider.updatePage(2);
                    widget.pageController.animateToPage(2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  }
                },
                phoneController: widget.phoneController,
                // phoneController: provider.phoneNoController,
                autoFocus: widget.isFocus,
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                height: 1,
                color: AppColor.GREY_LIGHT,
                width: double.infinity,
              ),
              Visibility(
                visible: provider.phoneErr,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Số điện thoại không đúng định dạng.',
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
