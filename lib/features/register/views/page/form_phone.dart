import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../commons/widgets/phone_widget.dart';
import '../../../../services/providers/register_provider.dart';

class FormPhone extends StatefulWidget {
  final TextEditingController phoneController;
  final bool isFocus;
  final Function(int) onEnterIntro;

  const FormPhone(
      {Key? key,
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
                  top: 150,
                ),
                width: double.infinity,
                child: Text(
                  'Xin chào, \nVui lòng nhập Số điện thoại\nđể đăng ký tài khoản',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PhoneWidget(
                onChanged: provider.updatePhone,
                phoneController: widget.phoneController,
                autoFocus: widget.isFocus,
              ),
              Visibility(
                visible: provider.phoneErr,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only( top: 10),
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
