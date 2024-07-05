import 'package:flutter/material.dart';
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
