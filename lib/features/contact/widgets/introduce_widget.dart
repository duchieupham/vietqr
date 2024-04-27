import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class ContactIntroWidget extends StatefulWidget {
  final Function() onSync;
  final Function(bool) onSelected;

  const ContactIntroWidget(
      {super.key, required this.onSync, required this.onSelected});

  @override
  State<ContactIntroWidget> createState() => _ContactIntroWidgetState();
}

class _ContactIntroWidgetState extends State<ContactIntroWidget> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.clear),
                    color: AppColor.TRANSPARENT,
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Text(
                      'Giới thiệu về Danh bạ QR',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    color: AppColor.BLACK_TEXT,
                    onPressed: () {
                      widget.onSelected(isSelect);
                    },
                  ),
                ],
              ),
              Image.asset(
                'assets/images/ic-contact-sync.png',
                width: 100,
                height: 120,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.BLACK_TEXT,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: '$textContent\n\n'),
                      TextSpan(text: '$textSecurity\n\n'),
                      TextSpan(text: 'Để biết thêm chi tiết, '),
                      TextSpan(
                        text: 'Xem chi tiết tại đây',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.BLUE_TEXT,
                          height: 1.5,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // ignore: deprecated_member_use
                            await launch(
                              'https://vietqr.vn/contact/introducing',
                              forceSafariVC: false,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Checkbox(
                      activeColor: AppColor.BLUE_TEXT,
                      value: isSelect,
                      shape: const CircleBorder(),
                      side: const BorderSide(color: AppColor.BLACK_TEXT),
                      onChanged: (value) async {
                        setState(() {
                          isSelect = value ?? false;
                        });
                      },
                    ),
                  ),
                  const Text(
                    'Không hiển thị ở lần sau',
                    style: TextStyle(color: AppColor.BLACK_TEXT, fontSize: 15),
                  ),
                ],
              ),
              MButtonWidget(
                title: 'Lưu danh bạ',
                isEnable: true,
                onTap: widget.onSync,
              )
            ],
          ),
        ),
      ],
    );
  }

  static String textContent =
      'Chia sẻ và bảo mật thông tin của bạn một cách tuyệt đối.Giờ đây, bạn có thể chia sẻ danh bạ của mình thông qua mã QR, đồng thời tận hưởng sự tiện lợi trong việc lưu trữ và quản lý. Kết nối nhanh chóng với bạn bè và người thân.';
  static String textSecurity =
      'Dữ liệu danh bạ của bạn sẽ được đồng bộ lên hệ thống của chúng tôi, và chúng tôi cam kết bảo mật thông tin của bạn một cách tuyệt đối.';
}
