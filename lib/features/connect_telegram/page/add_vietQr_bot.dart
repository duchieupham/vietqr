import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class AddVietQrPage extends StatelessWidget {
  const AddVietQrPage({Key? key}) : super(key: key);
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
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
            Text(
              'Tạo nhóm mới Telegram, hoặc nhóm quản trị của bạn',
              style: TextStyle(fontSize: 12),
            ),
            height: 60),
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
            RichText(
              text: TextSpan(
                text: 'Sao chép thông tin ',
                style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'chat id',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: ' của bạn.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            height: 60),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget _buildLinkVietQrBot() {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'Chọn truy cập đường dẫn ',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
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
          child: Icon(
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
        Text(
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
              SizedBox(
                width: 12,
              ),
              Text(
                '@vietqrbot',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              )
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
              SizedBox(
                width: 12,
              ),
              Text(
                '@raw_data_bot',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
            text:
                'VietQR Bot sẽ gửi thông tin BĐSD về nhóm Telegram của bạn.\nRawDataBot sẽ giúp bạn lấy thông tin',
            style: TextStyle(fontSize: 12, color: AppColor.BLACK),
            children: const <TextSpan>[
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: child,
    );
  }
}
