import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/measure_size.dart';
import 'package:vierqr/commons/widgets/step_progress.dart';
import 'package:vierqr/features/bank_card/widgets/no_service_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/platform_dto.dart';

class SharingConnectMedia extends StatefulWidget {
  final List<PlatformItem> list;
  final BankAccountDTO dto;
  final VoidCallback onHome;
  const SharingConnectMedia(
      {super.key, required this.list, required this.dto, required this.onHome});

  @override
  State<SharingConnectMedia> createState() => _SharingConnectMediaState();
}

class _SharingConnectMediaState extends State<SharingConnectMedia> {
  ValueNotifier<double> heightNotifier = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chia sẻ Biến động số động',
            style: TextStyle(
                color: AppColor.BLACK,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const SizedBox(
            height: 15,
          ),
          (widget.list.isEmpty || widget.list.length == 1)
              ? NoServiceWidget(
                  bankSelect: widget.dto,
                  onHome: () {
                    widget.onHome.call();
                  },
                )
              : ValueListenableBuilder<double>(
                  valueListenable: heightNotifier,
                  builder: (context, height, child) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: height + 20,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 10,
                            right: 30,
                            bottom: 0,
                            child: MeasureSize(
                              onChange: (p0) {
                                heightNotifier.value = p0.height;
                              },
                              child: StepProgressView(
                                  curStep: 1,
                                  height: 45 * widget.list.length.toDouble(),
                                  listItem: List.generate(widget.list.length,
                                      (index) {
                                    return SizedBox(
                                      // width: 310,
                                      height: 40,
                                      child: widget
                                              .list[index].platformId.isEmpty
                                          ? const SizedBox.shrink()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColor.BLACK
                                                              .withOpacity(0.1),
                                                          spreadRadius: 1,
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 2),
                                                        )
                                                      ]),
                                                  child: XImage(
                                                    imagePath:
                                                        _buildIconPlatform(
                                                            widget.list[index]
                                                                .platform),
                                                    height: 28,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget
                                                            .list[index]
                                                            .platformName
                                                            .isEmpty
                                                        ? 'Chia sẻ biến động số dư'
                                                        : widget.list[index]
                                                            .platformName,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text(
                                                  'Hoạt động',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.GREEN),
                                                ),
                                              ],
                                            ),
                                    );
                                  }),
                                  activeColor: Colors.black),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              width: double.infinity,
                              height: 60,
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Image(
                                      image: ImageUtils.instance
                                          .getImageNetWork(widget.dto.imgId),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.dto.bankAccount,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          widget.dto.userBankName,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      widget.onHome.call();
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        gradient: VietQRTheme
                                            .gradientColor.brightBlueLinear,
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
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  String _buildIconPlatform(String platform) {
    String img = '';
    switch (platform) {
      case 'Google Chat':
        img = ImageConstant.logoGGChatHome;
        break;
      case 'Telegram':
        img = ImageConstant.logoTelegramDash;
        break;
      case 'Lark':
        img = ImageConstant.logoLarkDash;
        break;
      case 'Slack':
        img = ImageConstant.logoSlackHome;
        break;
      case 'Discord':
        img = ImageConstant.logoDiscordHome;
        break;
      case 'Google Sheet':
        img = ImageConstant.logoGGSheetHome;
        break;
      default:
    }

    return img;
  }
}
