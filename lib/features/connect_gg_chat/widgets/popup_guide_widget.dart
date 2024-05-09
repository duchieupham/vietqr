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
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  guideStep1(),
                  guideStep2(),
                  guideStep3(),
                  guideStep4(),
                  guideStep5(),
                  guideStep6(),
                ],
              ),
            ),
            _buildPageIndicator(),
            SizedBox(height: 10),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget guideStep1() {
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
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: MButtonWidget(
        //     // margin: EdgeInsets.symmetric(horizontal: 40),
        //     height: 50,
        //     width: double.infinity,
        //     margin: EdgeInsets.zero,
        //     isEnable: true,
        //     colorDisableBgr: AppColor.GREY_BUTTON,
        //     colorDisableText: AppColor.BLACK,
        //     title: '',
        //     onTap: () {
        //       _pageController.nextPage(
        //           duration: Duration(milliseconds: 300),
        //           curve: Curves.easeInOut);
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Icon(Icons.arrow_forward, color: AppColor.BLUE_TEXT, size: 20),
        //         Text('Tiếp theo',
        //             style: TextStyle(fontSize: 15, color: AppColor.WHITE)),
        //         Padding(
        //           padding: const EdgeInsets.only(right: 10),
        //           child: Icon(Icons.arrow_forward,
        //               color: AppColor.WHITE, size: 20),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget guideStep2() {
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
            Container(
              width: 350,
              height: 350,
              child: Image.asset(
                "assets/images/step2.png",
              ),
            ),
            SizedBox(
              height: 50,
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
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       MButtonWidget(
        //         height: 50,
        //         width: MediaQuery.of(context).size.width * 0.4,
        //         isEnable: true,
        //         margin: EdgeInsets.only(right: 10),
        //         colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
        //         colorEnableText: AppColor.BLUE_TEXT,
        //         title: 'Trở về',
        //         onTap: () {
        //           _pageController.previousPage(
        //               duration: Duration(milliseconds: 300),
        //               curve: Curves.easeInOut);
        //         },
        //       ),
        //       MButtonWidget(
        //         // margin: EdgeInsets.symmetric(horizontal: 40),
        //         height: 50,
        //         margin: EdgeInsets.zero,
        //         width: MediaQuery.of(context).size.width * 0.4,
        //         isEnable: true,
        //         colorDisableBgr: AppColor.GREY_BUTTON,
        //         colorDisableText: AppColor.BLACK,
        //         title: '',
        //         onTap: () {
        //           _pageController.nextPage(
        //               duration: Duration(milliseconds: 300),
        //               curve: Curves.easeInOut);
        //         },
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Icon(Icons.arrow_forward,
        //                 color: AppColor.BLUE_TEXT, size: 20),
        //             Text('Tiếp theo',
        //                 style: TextStyle(fontSize: 15, color: AppColor.WHITE)),
        //             Padding(
        //               padding: const EdgeInsets.only(right: 10),
        //               child: Icon(Icons.arrow_forward,
        //                   color: AppColor.WHITE, size: 20),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget guideStep3() {
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

  Widget guideStep4() {
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

  Widget guideStep5() {
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

  Widget guideStep6() {
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

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? AppColor.BLUE_TEXT : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons() {
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
    } else if (_currentPage == 5) {
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
