import 'package:flutter/material.dart';
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
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                    color: AppColor.textBlack,
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  textContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColor.textBlack,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
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
                      side: const BorderSide(color: AppColor.textBlack),
                      onChanged: (value) async {
                        setState(() {
                          isSelect = value ?? false;
                        });
                      },
                    ),
                  ),
                  const Text(
                    'Không hiển thị ở lần sau',
                    style: TextStyle(color: AppColor.textBlack, fontSize: 15),
                  ),
                ],
              ),
              MButtonWidget(
                title: 'Đồng bộ danh bạ',
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
      'Đồng bộ danh bạ để hiển thị thông tin dưới dạng QR.Bạn có thể chia sẻ dễ dàng thông tin danh bạ của mình với mọi người';
}
