import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../layouts/m_button_widget.dart';

class PopupGuideWidget extends StatefulWidget {
  const PopupGuideWidget({super.key});

  @override
  State<PopupGuideWidget> createState() => _PopupGuideWidgetState();
}

class _PopupGuideWidgetState extends State<PopupGuideWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: PageView(
            children: [
              guildeStep1(),
              guildeStep2(),
            ],
          )),
    );
  }

  Widget guildeStep1() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              child: Text(
                'Hướng dẫn lấy thông tin \nWebhook trên Google Chat',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 350,
              child: Image.asset(
                "assets/images/step1.png",
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: MButtonWidget(
                // margin: EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                width: double.infinity,
                isEnable: true,
                colorDisableBgr: AppColor.GREY_BUTTON,
                colorDisableText: AppColor.BLACK,
                title: '',
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_forward,
                        color: AppColor.BLUE_TEXT, size: 20),
                    Text('Tiếp theo',
                        style: TextStyle(fontSize: 15, color: AppColor.WHITE)),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_forward,
                          color: AppColor.WHITE, size: 20),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget guildeStep2() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              child: Text(
                'Hướng dẫn lấy thông tin \nWebhook',
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
