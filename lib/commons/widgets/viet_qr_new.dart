import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:wakelock/wakelock.dart';

class VietQrNew extends StatefulWidget {
  final QRGeneratedDTO? qrGeneratedDTO;
  final String? qrCode;
  final String? content;
  final double? width;
  final double? height;
  final double? paddingHorizontal;

  const VietQrNew({
    super.key,
    this.qrGeneratedDTO,
    this.content,
    this.width,
    this.height,
    this.qrCode,
    this.paddingHorizontal,
  });

  @override
  State<VietQrNew> createState() => _VietQrState();
}

class _VietQrState extends State<VietQrNew> {
  bool get small => MediaQuery.of(context).size.height < 800;

  @override
  void initState() {
    super.initState();
    // Bật chế độ giữ màn hình sáng
    if (Provider.of<AuthProvider>(context, listen: false)
        .settingDTO
        .keepScreenOn) {
      Wakelock.enable();
    }

    // setBrightness(1.0);
  }

  @override
  void dispose() {
    if (!mounted) return;
    // Tắt chế độ giữ màn hình sáng khi widget bị hủy

    Wakelock.disable();

    // resetBrightness();
    super.dispose();
  }

  double get paddingHorizontal => 45;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              widget.paddingHorizontal ?? (small ? 60 : paddingHorizontal)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: small ? 16 : 24, vertical: small ? 12 : 24),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                QrImage(
                  data: widget.qrGeneratedDTO?.qrCode ?? widget.qrCode ?? '',
                  size: widget.width ?? (small ? 180 : 250),
                  version: QrVersions.auto,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(30, 30),
                  ),
                ),
                SizedBox(
                  width: widget.width ?? (250),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, provider, _) {
                          return Padding(
                            padding: EdgeInsets.only(left: small ? 20 : 6),
                            child: Image.asset(
                              'assets/images/logo_vietgr_payment.png',
                              width: 62,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: small ? 20 : 10),
                        child: Image.asset(
                          'assets/images/ic-napas247.png',
                          width: 70,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
