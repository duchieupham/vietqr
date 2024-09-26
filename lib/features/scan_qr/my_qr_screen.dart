import 'package:flutter/material.dart';

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  @override
  State<MyQrScreen> createState() => _MyQrScreenState();
}

class _MyQrScreenState extends State<MyQrScreen> {
  final GlobalKey globalKey = GlobalKey();

  Future<void> share({required String name}) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        textSharing: 'VietId of $name',
        key: globalKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'My QR'),
      body: Column(
        children: [
          const SizedBox(height: 30),
          RepaintBoundaryWidget(
            globalKey: globalKey,
            builder: (key) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 45, right: 45, top: 0, bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: VietQr(
                      qrCode: SharePrefUtils.getWalletID(),
                      qrGeneratedDTO: null,
                    ),
                  ),
                  Text(
                    SharePrefUtils.getProfile().fullName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              );
            },
          ),
          const Spacer(
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonWidget(
              width: double.infinity,
              height: 40,
              text: 'Chia sẻ',
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              borderRadius: 8,
              enableShadow: true,
              function: () {
                share(name: SharePrefUtils.getProfile().fullName);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
