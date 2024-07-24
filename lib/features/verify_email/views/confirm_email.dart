import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/textfield_type.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class EmailInputPage extends StatefulWidget {
  final TextEditingController emailController;
  final VoidCallback onContinue;

  EmailInputPage({
    required this.onContinue,
    required this.emailController,
    Key? key,
  }) : super(key: key);

  @override
  State<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  String? _emailError;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailRegex.hasMatch(email);
  }

  void validateEmail(String email) {
    if (email.isEmpty || !isValidEmail(email)) {
      setState(() {
        _emailError =
            'Email không hợp lệ. Vui lòng kiểm tra lại thông tin của bạn.';
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.emailController.addListener(() {
      validateEmail(widget.emailController.text);
    });
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MButtonWidget(
          height: 50,
          title: 'Tiếp tục',
          margin: EdgeInsets.zero,
          isEnable:
              _emailError == null && widget.emailController.text.isNotEmpty,
          onTap: widget.onContinue,
          colorDisableBgr: AppColor.GREY_BUTTON,
        ),
      ),
      backgroundColor: AppColor.WHITE,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: XImage(
                          imagePath: 'assets/images/logo-email.png',
                          width: 80,
                        ),
                      ),
                      Text(
                        'Xác thực thông tin Email của bạn',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Nhận ngay khuyến mãi sử dụng dịch vụ VietQR miễn phí 01 tháng',
                        style: TextStyle(fontSize: 11),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              XImage(
                                imagePath:
                                    'assets/images/ic-noti-bdsd-black.png',
                                width: 30,
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Nhận thông báo biến động số dư',
                                  style: TextStyle(fontSize: 11),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              XImage(
                                imagePath: 'assets/images/ic-earth-black.png',
                                width: 30,
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Chia sẻ BĐSD qua nền tảng mạng xã hội',
                                  style: TextStyle(fontSize: 11),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              XImage(
                                imagePath: 'assets/images/ic-store-black.png',
                                width: 30,
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  'Quản lý doanh thu các cửa hàng',
                                  style: TextStyle(fontSize: 11),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email*',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    MTextFieldCustom(
                      isObscureText: false,
                      maxLines: 1,
                      showBorder: false,
                      enable: true,
                      fillColor: AppColor.WHITE,
                      value: widget.emailController.text,
                      autoFocus: true,
                      textFieldType: TextfieldType.DEFAULT,
                      title: '',
                      hintText: '',
                      inputType: TextInputType.emailAddress,
                      keyboardAction: TextInputAction.next,
                      // onSubmitted: (value) {
                      //   if(validateEmail(value))
                      //   widget.onContinue();
                      // },
                      onChange: (value) {
                        widget.emailController.text = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Nhập email tại đây',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColor.GREY_TEXT,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.BLUE_TEXT),
                        ),
                      ),
                    ),
                    if (_emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          _emailError!,
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
