import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class CreateWebhookPage extends StatelessWidget {
  const CreateWebhookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildBgItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trong giao diện group chat của Lark:'),
                RichText(
                  text: TextSpan(
                    text: '- Chọn nút "..." > ',
                    style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                    children: const <TextSpan>[
                      TextSpan(
                          text: '"Setting"',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            pathImageTutorial: 'assets/images/intro1.png'),
        const SizedBox(
          height: 12,
        ),
        _buildBgItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '- Chọn mục > ',
                    style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                    children: const <TextSpan>[
                      TextSpan(
                          text: '"Bot" > "Add Bot"',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
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
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            pathImageTutorial: 'assets/images/intro2.png'),
        const SizedBox(
          height: 12,
        ),
        _buildBgItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            pathImageTutorial: 'assets/images/intro3.png'),
        const SizedBox(
          height: 12,
        ),
        _buildBgItem(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '- Chọn',
                    style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                    children: const <TextSpan>[
                      TextSpan(
                          text: ' "Coppy" ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      TextSpan(text: 'ở mục', style: TextStyle(fontSize: 12)),
                      TextSpan(
                          text: ' "Webhook Url" ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
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
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            pathImageTutorial: 'assets/images/intro4.png'),
        const SizedBox(
          height: 12,
        ),
        _buildBgItem(
          RichText(
            text: TextSpan(
              text: 'Khai báo',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
              children: const <TextSpan>[
                TextSpan(
                    text: ' "Webhook Url" ',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'ở bước tiếp theo.', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
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

  Widget _buildBgItem(Widget child, {String pathImageTutorial = ''}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: Row(
        children: [
          Expanded(flex: 3, child: child),
          if (pathImageTutorial.isNotEmpty)
            Expanded(flex: 2, child: Image.asset(pathImageTutorial))
        ],
      ),
    );
  }
}
