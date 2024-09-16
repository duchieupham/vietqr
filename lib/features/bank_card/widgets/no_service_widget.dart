import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/features/home/widget/item_service.dart';
import 'package:vierqr/models/bank_account_dto.dart';

class NoServiceWidget extends StatelessWidget {
  final BankAccountDTO bankSelect;
  final VoidCallback onHome;
  const NoServiceWidget({
    super.key,
    required this.bankSelect,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE1EFFF),
            Color(0xFFE5F9FF),
          ],
          end: Alignment.centerRight,
          begin: Alignment.centerLeft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 60,
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(5)),
                child: Image(
                  image: ImageUtils.instance.getImageNetWork(bankSelect.imgId),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bankSelect.bankAccount,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      bankSelect.userBankName,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  onHome.call();
                },
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: VietQRTheme.gradientColor.brightBlueLinear,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Kết nối mới',
                    style: TextStyle(
                      color: AppColor.WHITE,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            width: 270,
            child: const Text(
              'Nhận thông tin biến động số dư cho tài khoản ngân hàng qua các nền tảng:',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ItemServiceRow(
                    pathIcon: ImageConstant.logoTelegramDash,
                    title: 'Telegram',
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.MEDIAS_SCREEN,
                          arguments: {'type': TypeConnect.TELE});
                      // Navigator.pushNamed(context, Routes.CONNECT_TELEGRAM);
                    }),
              ),
              Expanded(
                flex: 1,
                child: ItemServiceRow(
                    pathIcon: ImageConstant.logoGGChatHome,
                    title: 'Google Chat',
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.MEDIAS_SCREEN,
                          arguments: {'type': TypeConnect.GG_CHAT});
                      // Navigator.pushNamed(context, Routes.QR_BOX);
                    }),
              ),
              Expanded(
                flex: 1,
                child: ItemServiceRow(
                    pathIcon: ImageConstant.logoDiscordHome,
                    title: 'Discord',
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.MEDIAS_SCREEN,
                          arguments: {'type': TypeConnect.DISCORD});
                      // Navigator.pushNamed(context, Routes.QR_BOX);
                    }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: ItemServiceRow(
                    pathIcon: ImageConstant.logoLarkDash,
                    title: 'Lark',
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.MEDIAS_SCREEN,
                          arguments: {'type': TypeConnect.LARK});
                    }),
              ),
              Expanded(
                flex: 1,
                child: ItemServiceRow(
                    pathIcon: ImageConstant.logoGGSheetHome,
                    title: 'Google Sheet',
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.MEDIAS_SCREEN,
                          arguments: {'type': TypeConnect.GG_SHEET});
                      // Navigator.pushNamed(context, Routes.QR_BOX);
                    }),
              ),
              Expanded(
                flex: 1,
                child: ItemServiceRow(
                    pathIcon: ImageConstant.logoSlackHome,
                    title: 'Slack',
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.MEDIAS_SCREEN,
                          arguments: {'type': TypeConnect.SLACK});
                      // Navigator.pushNamed(context, Routes.QR_BOX);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
