import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vierqr/layouts/image/x_image.dart';

import '../../../commons/constants/configurations/app_images.dart';
import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/enums/enum_type.dart';
import '../../../commons/utils/image_utils.dart';
import '../../../commons/widgets/dialog_widget.dart';
import '../../../commons/widgets/separator_widget.dart';
import '../../../models/connect_gg_chat_info_dto.dart';
import '../blocs/connect_media_bloc.dart';
import '../states/connect_media_states.dart';

class InfoMediaScreen extends StatelessWidget {
  final Function() onPopup;
  final Function() onDelete;
  final Function(String) onRemoveBank;

  final InfoMediaDTO dto;
  // final ConnectGgChatStates state;
  const InfoMediaScreen(
      {super.key,
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
    for (int i = 0; i < dto.banks!.length; i++) {
      listWidget.add(_itemBank(dto.banks![i]));
      if (i != dto.banks!.length - 1) {
        listWidget.add(const MySeparator(
          color: AppColor.GREY_DADADA,
        ));
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 45, 20, 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoConnect(),
            const SizedBox(height: 35),
            _bankList(listWidget),
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

  Widget _infoConnect() {
    return Column(
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                dto.webhook ?? '-',
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
        InkWell(
          onTap: () {
            Clipboard.setData(new ClipboardData(text: dto.webhook ?? ''));
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
                    size: 12,
                    color: AppColor.BLUE_TEXT,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Sao chép',
                    style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSharing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        const Text(
          'Thông tin chia sẻ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 30),
        const Text(
          'Cấu hình chia sẻ loại giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _setting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cài đặt',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: onPopup,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Image.asset(
                    'assets/images/ic-card-blue.png',
                    width: 40,
                    height: 35,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Thêm tài khoản ngân hàng',
                  style: TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
                )
              ],
            ),
          ),
        ),
        MySeparator(color: AppColor.GREY_DADADA),
        InkWell(
          onTap: onDelete,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 18, bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Image.asset(
                    'assets/images/ic-cancel-red.png',
                    height: 20,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  'Huỷ kết nối Google Chat',
                  style: TextStyle(fontSize: 15, color: AppColor.RED_TEXT),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bankList(List<Widget> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ...list,
      ],
    );
  }

  Widget _itemBank(BankInfoGgChat bank) {
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
                    image: ImageUtils.instance.getImageNetWork(bank.imgId!),
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
              onRemoveBank(bank.bankId!);
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
        Theme(
          data: ThemeData(
            unselectedWidgetColor: AppColor.GREY_DADADA,
            checkboxTheme: CheckboxThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            checkColor: AppColor.WHITE,
            activeColor: AppColor.BLUE_TEXT,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
