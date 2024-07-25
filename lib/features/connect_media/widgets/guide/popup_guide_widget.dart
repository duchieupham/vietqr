import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/features/connect_media/widgets/guide/discord_guide_widget.dart';
import 'package:vierqr/features/connect_media/widgets/guide/sheet_guide_widget.dart';
import 'package:vierqr/features/connect_media/widgets/guide/slack_guide_widget.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../../layouts/m_button_widget.dart';

class PopupGuideWidget extends StatefulWidget {
  final TypeConnect type;
  const PopupGuideWidget({super.key, required this.type});

  @override
  State<PopupGuideWidget> createState() => _PopupGuideWidgetState();
}

class _PopupGuideWidgetState extends State<PopupGuideWidget> {
  final PageController _pageController = PageController();
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

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    String webhook = 'webhook';

    double height = 0.0;

    switch (widget.type) {
      case TypeConnect.GG_CHAT:
        name = 'Google Chat';
        break;
      case TypeConnect.TELE:
        name = 'Telegram';
        webhook = 'Chat ID';
        break;
      case TypeConnect.LARK:
        name = 'Lark';

        break;
      case TypeConnect.SLACK:
        name = 'Slack';

        break;
      case TypeConnect.DISCORD:
        name = 'Discord';

        break;
      case TypeConnect.GG_SHEET:
        name = 'Google Sheet';

        break;
      default:
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        height: MediaQuery.of(context).size.height *
            (widget.type == TypeConnect.SLACK ? 0.85 : 0.8),
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
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(
                    'Hướng dẫn lấy thông tin \n$webhook trên $name',
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
                      ] else if (widget.type == TypeConnect.TELE)
                        guideTele()
                      else if (widget.type == TypeConnect.DISCORD) ...[
                        const DiscordGuide1Widget(),
                        const DiscordGuide2Widget()
                      ] else if (widget.type == TypeConnect.SLACK) ...[
                        const SlackGuide1Widget(),
                        const SlackGuide2Widget(),
                        const SlackGuide3Widget(),
                        const SlackGuide4Widget(),
                        const SlackGuide5Widget(),
                      ] else if (widget.type == TypeConnect.GG_SHEET) ...[
                        const SheetGuide1Widget(),
                        const SheetGuide2Widget(),
                        const SheetGuide3Widget(),
                        const SheetGuide4Widget(),
                        const SheetGuide5Widget(),
                        const SheetGuide6Widget(),
                        const SheetGuide7Widget(),
                      ],
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
                child: const Icon(
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

  Widget guideTele() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            _launchUrl('https://t.me/vietqrbot');
          },
          child: _buildBgItem(
            _buildLinkVietQrBot(),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        _buildBgItem(
            const Text(
              'Tạo nhóm mới Telegram, hoặc nhóm quản trị của bạn',
              style: TextStyle(fontSize: 12),
            ),
            height: 80),
        const SizedBox(
          height: 12,
        ),
        _buildBgItem(
          _buildAddBot(context),
        ),
        const SizedBox(
          height: 12,
        ),
        _buildBgItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Sao chép thông tin ',
                    style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'chat id',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: ' của bạn.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                RichText(
                  text: const TextSpan(
                    text: '(chat id ',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColor.BLACK,
                        fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'của nhóm Telegram sẽ có định dạng ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.normal)),
                      TextSpan(
                        text: '-xxxxxxxxxx)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            height: 80),
      ],
    );
  }

  Widget guideStep1() {
    if (widget.type == TypeConnect.LARK) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro1.png",
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const SizedBox(
            width: double.infinity,
            height: 20,
            child: Text(
              'Trong giao diện group chat của Lark:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          RichText(
            text: const TextSpan(
              text: '- Chọn nút "..." > ',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: <TextSpan>[
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
        SizedBox(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step1.png",
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const SizedBox(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 1 - Tạo Nhóm Chat',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
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
          SizedBox(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro2.png",
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          RichText(
            text: const TextSpan(
              text: '- Chọn mục > ',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: <TextSpan>[
                TextSpan(
                    text: '"Bot" > "Add Bot"',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          RichText(
            text: const TextSpan(
              text: '- Thêm',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: <TextSpan>[
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
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step2.png",
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const SizedBox(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 2 - Thiết lập thông tin Nhóm Chat',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
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
          SizedBox(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro3.png",
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            '- Đặt tên và mô tả cho Bot.',
            style: TextStyle(fontSize: 12),
          ),
          RichText(
            text: const TextSpan(
              text: '- Chọn',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: <TextSpan>[
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
        SizedBox(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step3.png",
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const SizedBox(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 3 - Truy cập vào Cài đặt',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
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
          SizedBox(
            width: 350,
            height: 350,
            child: Image.asset(
              "assets/images/intro4.png",
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          RichText(
            text: const TextSpan(
              text: '- Chọn',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: <TextSpan>[
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
            text: const TextSpan(
              text: '- Chọn',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: <TextSpan>[
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
        SizedBox(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step4.png",
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const SizedBox(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 4 - Khởi tạo Webhook',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
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
        SizedBox(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step5.png",
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const SizedBox(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 5 - Cấu hình Webhook',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
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
        SizedBox(
          width: 350,
          height: 350,
          child: Image.asset(
            "assets/images/step6.png",
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const SizedBox(
          width: double.infinity,
          height: 20,
          child: Text(
            'Bước 6 - Lấy thông tin Webhook URL',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
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
      case TypeConnect.DISCORD:
        page = 2;
        break;
      case TypeConnect.SLACK:
        page = 5;
        break;
      case TypeConnect.GG_SHEET:
        page = 7;
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
      case TypeConnect.DISCORD:
        page = 1;
        break;
      case TypeConnect.SLACK:
        page = 4;
        break;
      case TypeConnect.GG_SHEET:
        page = 6;
        break;
      default:
    }
    if (_currentPage == 0) {
      if (widget.type == TypeConnect.TELE) {
        return MButtonWidget(
          margin: EdgeInsets.zero,
          height: 50,
          width: double.infinity,
          isEnable: true,
          colorDisableBgr: AppColor.GREY_BUTTON,
          colorDisableText: AppColor.BLACK,
          title: 'Hoàn thành',
          onTap: () {
            Navigator.of(context).pop();
          },
        );
      }
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
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_forward, color: AppColor.BLUE_TEXT, size: 20),
            Text('Tiếp theo',
                style: TextStyle(fontSize: 15, color: AppColor.WHITE)),
            Padding(
              padding: EdgeInsets.only(right: 10),
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
            margin: const EdgeInsets.only(right: 10),
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
            colorEnableText: AppColor.BLUE_TEXT,
            title: 'Trở về',
            onTap: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
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
            margin: const EdgeInsets.only(right: 10),
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
            colorEnableText: AppColor.BLUE_TEXT,
            title: 'Trở về',
            onTap: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
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
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward, color: AppColor.BLUE_TEXT, size: 20),
                Text('Tiếp theo',
                    style: TextStyle(fontSize: 15, color: AppColor.WHITE)),
                Padding(
                  padding: EdgeInsets.only(right: 10),
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

  Widget _buildLinkVietQrBot() {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: const TextSpan(
              text: 'Chọn truy cập đường dẫn ',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: <TextSpan>[
                TextSpan(
                    text: 't.me/vietqrbot',
                    style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT)),
                TextSpan(
                  text:
                      ' để kết nối với VIETQR Bot. Chọn "Start" để bắt đầu kết nối',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          height: 25,
          width: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColor.GREY_BUTTON),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: AppColor.BLUE_TEXT,
          ),
        )
      ],
    );
  }

  Widget _buildAddBot(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thêm 2 Bot dưới đây vào nhóm của bạn:',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: () {
            FlutterClipboard.copy('@vietqrbot').then(
              (value) => Fluttertoast.showToast(
                msg: 'Đã sao chép',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).hintColor,
                fontSize: 15,
                webBgColor: 'rgba(255, 255, 255)',
                webPosition: 'center',
              ),
            );
          },
          child: Row(
            children: [
              Image.asset(
                'assets/images/avt-vietqr.png',
                width: 25,
                height: 25,
              ),
              const SizedBox(
                width: 12,
              ),
              const Text(
                '@vietqrbot',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/ic-copy-blue.png',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        InkWell(
          onTap: () {
            FlutterClipboard.copy('@raw_data_bot').then(
              (value) => Fluttertoast.showToast(
                msg: 'Đã sao chép',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).hintColor,
                fontSize: 15,
                webBgColor: 'rgba(255, 255, 255)',
                webPosition: 'center',
              ),
            );
          },
          child: Row(
            children: [
              Image.asset(
                'assets/images/avt-raw-data-bot.png',
                width: 25,
                height: 25,
              ),
              const SizedBox(
                width: 12,
              ),
              const Text(
                '@raw_data_bot',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Image.asset(
                'assets/images/ic-copy-blue.png',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: const TextSpan(
            text:
                'VietQR Bot sẽ gửi thông tin BĐSD về nhóm Telegram của bạn.\nRawDataBot sẽ giúp bạn lấy thông tin',
            style: TextStyle(fontSize: 12, color: AppColor.BLACK),
            children: <TextSpan>[
              TextSpan(
                  text: 'chat id',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBgItem(Widget child, {double? height}) {
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: child,
    );
  }
}
