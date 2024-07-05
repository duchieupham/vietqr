import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/features/connect_lark/views/webhook_lark_screen.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class ConnectLarkNewScreen extends StatelessWidget {
  const ConnectLarkNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  int currentPageIndex = 0;
  bool hasInfo = false;
  PageController _pageController = PageController(initialPage: 0);
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _bottomButton(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            leadingWidth: 100,
            leading: InkWell(
              onTap: () {
                if (currentPageIndex > 0 && hasInfo == false) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 25,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "Trở về",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  AppImages.icLogoVietQr,
                  width: 95,
                  fit: BoxFit.fitWidth,
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: WeebhookLarkScreen(
                textController: _textEditingController,
                controller: _pageController,
                onSubmitInput: (value) {
                  // _provider.setUnFocusNode();
                  // _bloc.add(CheckWebhookUrlEvent(url: value));
                },
                onChangeInput: (text) {
                  // provider.validateInput(text);
                },
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomButton() {
    bool isEnable = true;
    String buttonText = '';
    if (currentPageIndex == 0) {
      buttonText = 'Bắt đầu kết nối';
    } else if (currentPageIndex == 1) {
      buttonText = 'Tiếp tục';
      isEnable = true;

      // isEnable = _provider.listBank.any((element) => element.value == true);
    } else if (currentPageIndex == 2) {
      buttonText = 'Tiếp tục';
      isEnable = true;

      // isEnable = _provider.listBank.any((element) => element.value == true);
    } else if (currentPageIndex == 3) {
      buttonText = 'Kết nối';
      isEnable = true;
      // if (_textEditingController.text == '') {
      //   isEnable = false;
      // } else {
      //   // isEnable = _provider.isValidWebhook;
      //   isEnable = true;
      // }
    } else if (currentPageIndex == 4) {
      buttonText = 'Hoàn thành';
    }

    Color textColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color iconColor = isEnable ? AppColor.WHITE : AppColor.BLACK;
    Color icon1Color = isEnable ? AppColor.BLUE_TEXT : AppColor.GREY_BUTTON;

    return Container(
      width: double.infinity,
      height: 70 + MediaQuery.of(context).viewInsets.bottom,
      child: MButtonWidget(
        margin: EdgeInsets.symmetric(horizontal: 40),
        height: 50,
        isEnable: isEnable,
        colorDisableBgr: AppColor.GREY_BUTTON,
        colorDisableText: AppColor.BLACK,
        title: '',
        onTap: () {
          switch (currentPageIndex) {
            case 0:
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 1:
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 2:
              // if (_textEditingController.text != '' &&
              //     _provider.isValidWebhook == true) {
              //   _provider.setUnFocusNode();
              //   _bloc.add(
              //       CheckWebhookUrlEvent(url: _textEditingController.text));
              // }
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 3:
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
              break;
            case 4:
              _pageController.jumpToPage(0);
              // initData();
              break;
            default:
              break;
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_forward, color: icon1Color, size: 20),
            Text(buttonText, style: TextStyle(fontSize: 15, color: textColor)),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_forward, color: iconColor, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
