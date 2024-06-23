import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/helper/dialog_helper.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/views/vietqr_id_card_view.dart';
import 'package:vierqr/features/home/widget/item_service.dart';
import 'package:vierqr/features/web_view/views/custom_inapp_webview.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class ServiceSection extends StatefulWidget {
  const ServiceSection({Key? key}) : super(key: key);

  @override
  State<ServiceSection> createState() => _ServiceSectionState();
}

class _ServiceSectionState extends State<ServiceSection> with DialogHelper {
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
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 120,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.CUSTOMER_VA_SPLASH);
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'assets/images/ic-invoice-3D.png',
                  width: 80,
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thu hộ hoá đơn\nqua tài khoản định danh',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '- Quản lý hoá đơn thanh toán.',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '- Áp dụng cho TK ngân hàng BIDV.',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
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
        ItemService(
            pathIcon: ImageConstant.logoTelegramDash,
            title: 'Telegram',
            onTap: () async {
              Navigator.pushNamed(context, Routes.CONNECT_TELEGRAM);
            }),
        ItemService(
            pathIcon: ImageConstant.logoLarkDash,
            title: 'Lark',
            onTap: () async {
              Navigator.pushNamed(context, Routes.CONNECT_LARK);
            }),
        ItemService(
            pathIcon: ImageConstant.logoGGChatHome,
            title: 'Google Chat',
            onTap: () async {
              Navigator.pushNamed(context, Routes.CONNECT_GG_CHAT_SCREEN);
              // Navigator.pushNamed(context, Routes.QR_BOX);
            }),
      ],
    );
  }

  Widget _buildListService(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        ItemService(
            pathIcon: ImageConstant.logoBdsd3D,
            title: 'Đăng ký\nnhận BĐSD',
            onTap: () {
              DialogWidget.instance.openMsgDialog(
                title: 'Tính năng đang bảo trì',
                msg: 'Vui lòng thử lại sau',
              );
            }),
        ItemService(
            pathIcon: ImageConstant.logoMobileMoney3D,
            title: 'Nạp tiền\nđiện thoại',
            onTap: () {
              Navigator.pushNamed(context, Routes.MOBILE_RECHARGE);
            }),
        ItemService(
            pathIcon: ImageConstant.icMB,
            title: 'Mở TK\nMB Bank',
            onTap: () {
              _launchUrl();
            }),
        ItemService(
            pathIcon: ImageConstant.logoLoginWeb3D,
            title: 'Đăng nhập\nweb',
            onTap: () {
              startBarcodeScanStream();
            }),
        ItemService(
            pathIcon: ImageConstant.ic3DRequestRegisterBank,
            title: 'Mở TK ngân hàng',
            onTap: () {
              Navigator.pushNamed(context, Routes.REGISTER_NEW_BANK);
            }),
        ItemService(
            pathIcon: ImageConstant.logoVietqrKiotDashboard,
            title: 'VietQR Kiot\n',
            onTap: () async {
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
        // ItemService(
        //   context,
        //   'assets/images/ic-business-3D.png',
        //   'Doanh nghiệp',
        //   () async {
        //     Navigator.pushNamed(context, Routes.BUSINESS);
        //   },
        // ),
        ItemService(
          pathIcon: ImageConstant.logoCheckAppVersion,
          title: 'Kiểm tra phiên bản App',
          onTap: () async {
            showDialogUpdateApp(context);
          },
        ),
        ItemService(
          pathIcon: ImageConstant.shortcutNfc,
          title: 'VQR-ID Card',
          onTap: () async {
            NavigatorUtils.navigatePage(context, VietQRIDCardView(),
                routeName: VietQRIDCardView.routeName);
          },
        ),
        ItemService(
          pathIcon: ImageConstant.icActiveTerminal,
          title: 'Kích hoạt máy bán hàng',
          onTap: () async {
            NavigatorUtils.navigatePage(
                context,
                CustomInAppWebView(
                  url: 'https://vietqr.vn/service/may-ban-hang/active?mid=0',
                  userId: SharePrefUtils.getProfile().userId,
                ),
                routeName: CustomInAppWebView.routeName);
          },
        ),
      ],
    );
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
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

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }
}
