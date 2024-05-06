import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/account/views/vietqr_id_card_view.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/home/widget/dialog_update.dart';
import 'package:vierqr/features/web_view/views/custom_inapp_webview.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

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
          startBarcodeScanStream();
        }),
        _buildItemService(
            context,
            'assets/images/ic-3D-request-register-bank.png',
            'Mở TK ngân hàng', () {
          Navigator.pushNamed(context, Routes.REGISTER_NEW_BANK);
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
        // _buildItemService(
        //   context,
        //   'assets/images/ic-business-3D.png',
        //   'Doanh nghiệp',
        //   () async {
        //     Navigator.pushNamed(context, Routes.BUSINESS);
        //   },
        // ),
        _buildItemService(
          context,
          'assets/images/logo-check-app-version.png',
          'Kiểm tra phiên bản App',
          () async {
            showDialog(
              barrierDismissible: false,
              context: NavigationService.navigatorKey.currentContext!,
              builder: (BuildContext context) {
                return DialogUpdateView(
                  onCheckUpdate: () {
                    context
                        .read<DashBoardBloc>()
                        .add(GetVersionAppEventDashboard(isCheckVer: true));
                  },
                );
              },
            );
          },
        ),
        _buildItemService(
          context,
          'assets/images/shortcut-nfc.png',
          'VQR-ID Card',
          () async {
            NavigatorUtils.navigatePage(context, VietQRIDCardView(),
                routeName: VietQRIDCardView.routeName);
          },
        ),
        _buildItemService(
          context,
          'assets/images/ic-active-terminal.png',
          'Kích hoạt máy bán hàng',
          () async {
            NavigatorUtils.navigatePage(
                context,
                CustomInAppWebView(
                  url: 'https://vietqr.vn/service/may-ban-hang/active?mid=0',
                  userId: SharePrefUtils.getProfile().userId,
                ),
                routeName: CustomInAppWebView.routeName);
          },
        ),
        _buildItemService(
          context,
          'assets/images/ic-active-terminal.png',
          'Kích hoạt GGChat',
          () {},
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
