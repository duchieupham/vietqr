import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/navigator/app_navigator.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../../../models/connect_gg_chat_info_dto.dart';

class InfoMediaScreen extends StatelessWidget {
  final Function() onPopup;
  final Function() onDelete;
  final Function(String) onRemoveBank;
  final TypeConnect type;

  final InfoMediaDTO dto;
  // final ConnectGgChatStates state;
  const InfoMediaScreen(
      {super.key,
      required this.type,
      required this.onPopup,
      required this.onDelete,
      required this.onRemoveBank,
      required this.dto});

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidget = [
      // _itemBank(),
      // MySeparator(
      //   color: AppColor.GREY_DADADA,
      // ),
    ];
    for (int i = 0; i < dto.banks.length; i++) {
      listWidget.add(_itemBank(dto.banks[i]));
      if (i != dto.banks.length - 1) {
        listWidget.add(const MySeparator(
          color: AppColor.GREY_DADADA,
        ));
      }
    }

    String mediaText = '';
    String img = '';

    switch (type) {
      case TypeConnect.GG_CHAT:
        mediaText = 'Google Chat';
        img = 'assets/images/ic-gg-chat-home.png';

        break;
      case TypeConnect.TELE:
        mediaText = 'Telegram';
        img = 'assets/images/logo-telegram.png';

        break;
      case TypeConnect.LARK:
        mediaText = 'Lark';
        img = 'assets/images/logo-lark.png';
        break;
      case TypeConnect.SLACK:
        mediaText = 'Slack';
        img = ImageConstant.logoSlackHome;
        break;
      case TypeConnect.DISCORD:
        mediaText = 'Discord';
        img = ImageConstant.logoDiscordHome;
        break;
      case TypeConnect.GG_SHEET:
        mediaText = 'Google Sheet';
        img = ImageConstant.logoGGSheetHome;
        break;
      default:
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoConnect(mediaText, img),
            const SizedBox(height: 35),
            _bankList(listWidget, mediaText),
            const SizedBox(height: 20),
            // _setting(),
            InkWell(
              onTap: onPopup,
              child: Container(
                // width: 250,
                padding: const EdgeInsets.only(left: 10, right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(colors: [
                      AppColor.D8ECF8,
                      AppColor.FFEAD9,
                      AppColor.F5C9D1,
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    XImage(
                      imagePath: 'assets/images/ic-suggest.png',
                      width: 30,
                    ),
                    Text(
                      'Bạn có muốn thêm TK ngân hàng để chia sẻ BĐSD?',
                      style: TextStyle(
                        color: AppColor.BLACK,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildInfoSharing(),
          ],
        ),
      ),
    );
  }

  Widget _infoConnect(String media, String img) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin kết nối',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nền tảng kết nối:',
              style: TextStyle(fontSize: 15),
            ),
            Row(
              children: [
                Text(
                  media,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  img,
                  width: 20,
                  fit: BoxFit.fitWidth,
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kết nối:',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              width: 220,
              child: Text(
                'Kết nối của Kiên',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const MySeparator(
          color: AppColor.GREY_DADADA,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type == TypeConnect.TELE ? 'Chat ID' : 'Webhook:',
              style: const TextStyle(fontSize: 15),
            ),
            Row(
              children: [
                SizedBox(
                  width: 220,
                  child: Text(
                    dto.chatId ?? '-',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: dto.chatId ?? ''));
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColor.BLUE_BGR,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.copy,
                          size: 12,
                          color: AppColor.BLUE_TEXT,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoSharing() {
    List<String> notificationTypes = [];
    List<String> notificationContents = [];
    for (var item in dto.notificationTypes) {
      String text = '';
      switch (item) {
        case 'RECON':
          text = 'Giao dịch có đối soát';
          break;
        case 'CREDIT':
          text = 'Giao dịch nhận tiền đến (+)';

          break;
        case 'DEBIT':
          text = 'Giao dịch chuyển tiền đi (-)';

          break;
        default:
          break;
      }
      notificationTypes.add(text);
    }

    for (var item in dto.notificationContents) {
      String text = '';
      switch (item) {
        case 'AMOUNT':
          text = 'Số tiền';
          break;
        case 'CONTENT':
          text = 'Nội dung thanh toán';
          break;
        case 'REFERENCE_NUMBER':
          text = 'Mã giao dịch';
          break;
        default:
          break;
      }
      notificationContents.add(text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        const Text(
          'Thông tin chia sẻ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        if (notificationTypes.isNotEmpty) ...[
          const SizedBox(height: 30),
          const Text(
            'Cấu hình chia sẻ loại giao dịch',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          ...notificationTypes.map(
            (e) => buildCheckboxRow(
              e,
              true,
              (value) {},
            ),
          ),
        ],
        if (notificationContents.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Cấu hình chia sẻ thông tin giao dịch',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          ...notificationContents.map(
            (e) => buildCheckboxRow(
              e,
              true,
              (value) {},
            ),
          ),
        ],
        const SizedBox(height: 20),
        if (notificationTypes.isNotEmpty && notificationContents.isNotEmpty)
          InkWell(
            onTap: () {
              NavigationService.push(Routes.UPDATE_SHARE_INFO_MEDIA,
                  arguments: {
                    'notificationTypes': dto.notificationTypes,
                    'notificationContents': dto.notificationContents,
                    'type': type,
                    'id': dto.id,
                  });
            },
            child: Container(
              // width: 250,
              padding: const EdgeInsets.only(left: 10, right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [
                    AppColor.D8ECF8,
                    AppColor.FFEAD9,
                    AppColor.F5C9D1,
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  XImage(
                    imagePath: 'assets/images/ic-suggest.png',
                    width: 30,
                  ),
                  Text(
                    'Bạn có muốn cập nhật thông tin chia sẻ?',
                    style: TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ...dto.notificationTypes.map((e) => buildCheckboxRow(e., isChecked, onChanged),)
      ],
    );
  }

  Widget _bankList(List<Widget> list, String media) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tài khoản ngân hàng',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Danh sách tài khoản ngân hàng được chia sẻ \nthông tin Biến động số dư qua $media.',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 10),
        ...list,
      ],
    );
  }

  Widget _itemBank(BankMedia bank) {
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
                  border: Border.all(width: 0.5, color: AppColor.GREY_DADADA),
                  image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(bank.imgId),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bank.bankAccount ?? '-',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bank.userBankName ?? '-',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              onRemoveBank(bank.bankId);
            },
            child: const Icon(
              Icons.remove_circle_outline,
              size: 25,
              color: AppColor.RED_TEXT,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCheckboxRow(
      String text, bool isChecked, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          value: isChecked,
          onChanged: onChanged,
          checkColor: AppColor.BLUE_TEXT,
          activeColor: AppColor.BLUE_BGR,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
