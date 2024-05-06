import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/enums/enum_type.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../commons/widgets/dialog_widget.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../blocs/connect_gg_chat_bloc.dart';
import '../states/connect_gg_chat_states.dart';

class InfoGgChatWidget extends StatelessWidget {
  final ConnectGgChatBloc bloc;
  // final ConnectGgChatStates state;
  const InfoGgChatWidget({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin kết nối',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nền tảng kết nối:',
                  style: TextStyle(fontSize: 15),
                ),
                Row(
                  children: [
                    Text(
                      'Google Chat',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      AppImages.icLogoGgChat,
                      width: 20,
                      fit: BoxFit.fitWidth,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            MySeparator(
              color: AppColor.GREY_DADADA,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Webhook:',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  width: 250,
                  child: Text(
                    'https://chat.google.com/xxxxxxxxxxxx',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Clipboard.setData(new ClipboardData(text: ''));
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  decoration: BoxDecoration(
                    color: AppColor.BLUE_TEXT.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.copy,
                        size: 15,
                        color: AppColor.BLUE_TEXT,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Sao chép',
                        style:
                            TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Text(
              'Tài khoản ngân hàng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Danh sách tài khoản ngân hàng được chia sẻ \nthông tin Biến động số dư qua Google Chat.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _itemBank() {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 75,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(''),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
