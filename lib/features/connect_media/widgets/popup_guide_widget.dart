import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../layouts/m_button_widget.dart';

class PopupGuideWidget extends StatefulWidget {
  final TypeConnect type;
  const PopupGuideWidget({super.key, required this.type});

  @override
  State<PopupGuideWidget> createState() => _PopupGuideWidgetState();
}

class _PopupGuideWidgetState extends State<PopupGuideWidget> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(
                    'Hướng dẫn lấy thông tin \nWebhook trên Google Chat',
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      if (widget.type == TypeConnect.GG_CHAT) ...[
                        guideStep1(),
                        guideStep2(),
                        guideStep3(),
                        guideStep4(),
                        guideStep5(),
                        guideStep6(),
                      ] else if (widget.type == TypeConnect.LARK) ...[
                        guideStep1(),
                        guideStep2(),
                        guideStep3(),
                        guideStep4(),
                      ]
                    ],
                  ),
                ),
                _buildPageIndicator(),
                const SizedBox(height: 10),
                _buildNavigationButtons(),
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
        ),
      ),
    );
  }

  Widget guideStep1() {
    if (widget.type == TypeConnect.LARK) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro1.png",
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            height: 20,
            child: Text(
              'Trong giao diện group chat của Lark:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          RichText(
            text: TextSpan(
              text: '- Chọn nút "..." > ',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
                TextSpan(
                    text: '"Setting"',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step1.png",
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 1 - Tạo Nhóm Chat',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: 30,
          child: Text(
            'Chọn button “Cuộc trò chuyện mới” -> “Tạo không gian”. ',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget guideStep2() {
    if (widget.type == TypeConnect.LARK) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro2.png",
            ),
          ),
          SizedBox(
            height: 50,
          ),
          RichText(
            text: TextSpan(
              text: '- Chọn mục > ',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
                TextSpan(
                    text: '"Bot" > "Add Bot"',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '- Thêm',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
                TextSpan(
                    text: ' "Custom Bot"',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step2.png",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 2 - Thiết lập thông tin Nhóm Chat',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: 30,
          child: Text(
            'Đặt tên Nhóm Chat, tuỳ chỉnh cấu hình.\nChọn button “Tạo”.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget guideStep3() {
    if (widget.type == TypeConnect.LARK) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro3.png",
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            '- Đặt tên và mô tả cho Bot.',
            style: TextStyle(fontSize: 12),
          ),
          RichText(
            text: TextSpan(
              text: '- Chọn',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
                TextSpan(
                    text: '"Add"',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step3.png",
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 3 - Truy cập vào Cài đặt',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: 30,
          child: Text(
            'Click chọn vào tên Nhóm Chat.\nChọn button menu “Ứng dụng và các công cụ tích hợp”.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget guideStep4() {
    if (widget.type == TypeConnect.LARK) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro4.png",
            ),
          ),
          SizedBox(
            height: 50,
          ),
          RichText(
            text: TextSpan(
              text: '- Chọn',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
                TextSpan(
                    text: ' "Coppy" ',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                TextSpan(text: 'ở mục', style: TextStyle(fontSize: 12)),
                TextSpan(
                    text: ' "Webhook Url" ',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: '- Chọn',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
                TextSpan(
                    text: ' "Finish"',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step4.png",
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 4 - Khởi tạo Webhook',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: 30,
          child: Text(
            'Chọn tab “Webhook”.\nChọn button “Thêm Webhook”.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget guideStep5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step5.png",
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 5 - Cấu hình Webhook',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: 30,
          child: Text(
            'Nhập tên “Webhook”.\nChọn button “Lưu”.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget guideStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step6.png",
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 6 - Lấy thông tin Webhook URL',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: 45,
          child: Text(
            'Chọn button “...” bên phải thông tin webhook.\nChọn button “Sao chép đường liên kết”.\nDán thông tin đã sao chép vào ứng dụng VietQR VN.',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    int page = 0;
    switch (widget.type) {
      case TypeConnect.GG_CHAT:
        page = 6;
        break;
      case TypeConnect.LARK:
        page = 4;
        break;
      case TypeConnect.TELE:
        page = 1;
        break;
      default:
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(page, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? AppColor.BLUE_TEXT : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons() {
    int page = 0;
    switch (widget.type) {
      case TypeConnect.GG_CHAT:
        page = 5;
        break;
      case TypeConnect.LARK:
        page = 3;
        break;
      case TypeConnect.TELE:
        page = 0;
        break;
      default:
    }
    if (_currentPage == 0) {
      return MButtonWidget(
        // margin: EdgeInsets.symmetric(horizontal: 40),
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.zero,
        isEnable: true,
        colorDisableBgr: AppColor.GREY_BUTTON,
        colorDisableText: AppColor.BLACK,
        title: '',
        onTap: () {
          _pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_forward, color: AppColor.BLUE_TEXT, size: 20),
            Text('Tiếp theo',
                style: TextStyle(fontSize: 15, color: AppColor.WHITE)),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_forward, color: AppColor.WHITE, size: 20),
            ),
          ],
        ),
      );
    } else if (_currentPage == page) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MButtonWidget(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.4,
            isEnable: true,
            margin: EdgeInsets.only(right: 10),
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
            colorEnableText: AppColor.BLUE_TEXT,
            title: 'Trở về',
            onTap: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          MButtonWidget(
            height: 50,
            margin: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width * 0.4,
            isEnable: true,
            colorDisableBgr: AppColor.GREY_BUTTON,
            colorDisableText: AppColor.BLACK,
            title: 'Hoàn thành',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MButtonWidget(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.4,
            isEnable: true,
            margin: EdgeInsets.only(right: 10),
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
            colorEnableText: AppColor.BLUE_TEXT,
            title: 'Trở về',
            onTap: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
          ),
          MButtonWidget(
            height: 50,
            margin: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width * 0.4,
            isEnable: true,
            colorDisableBgr: AppColor.GREY_BUTTON,
            colorDisableText: AppColor.BLACK,
            title: '',
            onTap: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward, color: AppColor.BLUE_TEXT, size: 20),
                Text('Tiếp theo',
                    style: TextStyle(fontSize: 15, color: AppColor.WHITE)),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.arrow_forward,
                      color: AppColor.WHITE, size: 15),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
