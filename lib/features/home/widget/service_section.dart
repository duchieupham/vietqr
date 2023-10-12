import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/home/widget/dialog_update.dart';
import 'package:vierqr/main.dart';

import 'nfc_adr_widget.dart';
import 'nfc_widget.dart';

class ServiceSection extends StatefulWidget {
  const ServiceSection({Key? key}) : super(key: key);

  @override
  State<ServiceSection> createState() => _ServiceSectionState();
}

class _ServiceSectionState extends State<ServiceSection> {
  bool isCheckApp = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Dịch vụ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildListService(context),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Mạng xã hội',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildSocialNetwork(context)
      ],
    );
  }

  Widget _buildSocialNetwork(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        _buildItemService(
            context, 'assets/images/logo-telegram-dash.png', 'Telegram',
            () async {
          Navigator.pushNamed(context, Routes.CONNECT_TELEGRAM);
        }),
        _buildItemService(context, 'assets/images/logo-lark-dash.png', 'Lark',
            () async {
          Navigator.pushNamed(context, Routes.CONNECT_LARK);
        }),
      ],
    );
  }

  Widget _buildListService(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        _buildItemService(
            context, 'assets/images/logo-bdsd-3D.png', 'Đăng ký\nnhận BĐSD',
            () {
          DialogWidget.instance.openMsgDialog(
            title: 'Tính năng đang bảo trì',
            msg: 'Vui lòng thử lại sau',
          );
        }),
        _buildItemService(context, 'assets/images/logo-mobile-money-3D.png',
            'Nạp tiền\nđiện thoại', () {
          Navigator.pushNamed(context, Routes.MOBILE_RECHARGE);
        }),
        _buildItemService(context, 'assets/images/ic-mb.png', 'Mở TK\nMB Bank',
            () {
          _launchUrl();
        }),
        _buildItemService(
            context, 'assets/images/logo-login-web-3D.png', 'Đăng nhập\nweb',
            () {
          DialogWidget.instance.openMsgDialog(
            title: 'Tính năng đang bảo trì',
            msg: 'Vui lòng thử lại sau',
          );
        }),
        _buildItemService(
            context,
            'assets/images/logo-vietqr-kiot-dashboard.png',
            'VietQR Kiot\n', () async {
          if (PlatformUtils.instance.isAndroidApp()) {
            final intent = AndroidIntent(
                action: 'action_view',
                data: Uri.encodeFull(
                    'https://play.google.com/store/apps/details?id=com.vietqr.kiot&hl=en_US'),
                package: 'com.vietqr.kiot');
            intent.launch();
          } else if (PlatformUtils.instance.isIOsApp()) {
            await DialogWidget.instance.openMsgDialog(
              title: 'Thông báo',
              msg:
                  'Chúng tôi đang bảo trì VietQR Kiot cho nền tảng iOS. Tính năng này sẽ sớm phụ vụ quý khách.',
              function: () {
                Navigator.pop(context);
              },
            );
          }
        }),
        _buildItemService(
          context,
          'assets/images/ic-business-3D.png',
          'Doanh nghiệp',
          () async {
            Navigator.pushNamed(context, Routes.BUSINESS);
          },
        ),
        _buildItemService(
          context,
          'assets/images/logo-check-app-version.png',
          'Kiểm tra phiên bản App',
          () async {
            showDialog(
              barrierDismissible: false,
              context: NavigationService.navigatorKey.currentContext!,
              builder: (BuildContext context) {
                return DialogUpdateView();
              },
            );
          },
        ),
        _buildItemService(
          context,
          'assets/images/shortcut-nfc.png',
          'Đọc thẻ NFC',
          () async {
            if (!(await NfcManager.instance.isAvailable())) {
              return DialogWidget.instance.openMsgDialog(
                title: 'Thông báo',
                msg:
                    'NFC có thể không được hỗ trợ hoặc có thể tạm thời bị tắt.',
                function: () {
                  Navigator.pop(context);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              );
            }

            if (Platform.isAndroid) {
              final data = await DialogWidget.instance
                  .openDialogIntroduce(child: NFCDialog());
              if (data != null) {
                if (data) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    DialogWidget.instance
                        .openDialogIntroduce(child: NFCWidget());
                  });
                }
              }
            } else if (Platform.isIOS) {
              NfcManager.instance.startSession(
                pollingOptions: {
                  NfcPollingOption.iso14443,
                  NfcPollingOption.iso15693
                },
                onDiscovered: (tag) async {
                  try {
                    final result = await handleTag(tag);
                    if (result == null) return;
                    await NfcManager.instance.stopSession(alertMessage: result);

                    Future.delayed(const Duration(seconds: 3), () {
                      DialogWidget.instance
                          .openDialogIntroduce(child: NFCWidget());
                    });
                  } catch (e) {
                    await NfcManager.instance.stopSession(alertMessage: '');
                  }
                },
              ).catchError((e) {});
            }
          },
        ),
      ],
    );
  }

  NfcTag? tag;

  Map<String, dynamic>? additionalData;

  Future<String?> handleTag(NfcTag tag) async {
    // this.tag = tag;
    // additionalData = {};
    //
    // Object? tech;
    //
    // if (Platform.isIOS) {
    //   tech = FeliCa.from(tag);
    //   if (tech is FeliCa) {
    //     final polling = await tech.polling(
    //       systemCode: tech.currentSystemCode,
    //       requestCode: FeliCaPollingRequestCode.noRequest,
    //       timeSlot: FeliCaPollingTimeSlot.max1,
    //     );
    //     additionalData!['manufacturerParameter'] =
    //         polling.manufacturerParameter;
    //   }
    // }

    return 'Hoàn tất.';
  }

  Future<void> _launchUrl() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/search?q=mbbank&c=apps&hl=vi-VN';
    } else {
      url = 'https://apps.apple.com/vn/app/mb-bank/id1205807363?l=vi';
    }

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Widget _buildItemService(
      BuildContext context, String pathIcon, String title, VoidCallback onTap) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: getDeviceType() == 'phone' ? width / 5 - 7 : 70,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              pathIcon,
              height: 45,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }
}
