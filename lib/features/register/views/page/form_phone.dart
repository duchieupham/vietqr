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
      {Key? key,
      required this.pageController,
      required this.phoneController,
      required this.isFocus,
      required this.onEnterIntro})
      : super(key: key);

  @override
  State<FormPhone> createState() => _FormPhoneState();
}

class _FormPhoneState extends State<FormPhone> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  top: 100,
                ),
                width: double.infinity,
                child: Text(
                  'Xin chào, vui lòng nhập\nSố điện thoại để đăng ký\ntài khoản VietQR VN',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
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
