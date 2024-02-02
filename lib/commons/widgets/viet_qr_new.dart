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

  const VietQrNew({
    super.key,
    this.qrGeneratedDTO,
    this.content,
    this.width,
    this.height,
    this.qrCode,
  });

  @override
  State<VietQrNew> createState() => _VietQrState();
}

class _VietQrState extends State<VietQrNew> {
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

  double get paddingHorizontal => 40;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  size: widget.width ?? 230,
                  version: QrVersions.auto,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(30, 30),
                  ),
                ),
                SizedBox(
                  width: widget.width ?? 230,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, provider, _) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: CachedNetworkImage(
                              imageUrl: provider.settingDTO.logoUrl,
                              height: 28,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
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
