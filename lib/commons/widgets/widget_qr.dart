import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:wakelock/wakelock.dart';

import 'dashed_line.dart';

class WidgetQr extends StatefulWidget {
  final QRGeneratedDTO? qrGeneratedDTO;
  final String? content;
  final bool isVietQR;
  final String? qrCode;
  final double? size;
  final bool isEmbeddedImage;

  const WidgetQr({
    super.key,
    required this.qrGeneratedDTO,
    this.content,
    this.isVietQR = false,
    this.isEmbeddedImage = false,
    this.qrCode,
    this.size,
  });

  @override
  State<WidgetQr> createState() => _VietQrState();
}

class _VietQrState extends State<WidgetQr> {
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    bool isSmallWidget = height < 800;

    if (!widget.isVietQR) {
      return QrImage(
        data: widget.qrCode ?? '',
        size: widget.size,
        version: QrVersions.auto,
        embeddedImage: widget.isEmbeddedImage
            ? null
            : const AssetImage('assets/images/ic-viet-qr-small.png'),
        embeddedImageStyle: widget.isEmbeddedImage
            ? null
            : QrEmbeddedImageStyle(size: const Size(30, 30)),
      );
    }

    if (widget.qrGeneratedDTO == null) return const SizedBox();

    return Container(
      width: width,
      margin: height < 750
          ? EdgeInsets.symmetric(horizontal: 10)
          : const EdgeInsets.symmetric(vertical: 8),
      padding: height < 750
          ? const EdgeInsets.only(bottom: 12, left: 30, right: 30)
          : const EdgeInsets.only(bottom: 12, left: 30, right: 30),
      decoration: BoxDecoration(
          color: AppColor.BG_BLUE, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: height < 750
                ? const EdgeInsets.only(
                    left: 16, right: 16, top: 24, bottom: 10)
                : const EdgeInsets.only(
                    left: 12, right: 12, top: 30, bottom: 12),
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Image.asset(
                    'assets/images/ic-viet-qr.png',
                    width: height < 750 ? width * 0.10 : width * 0.19,
                  ),
                ),
                if (height > 750) const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: QrImage(
                    size: height < 750 ? height / 3.5 : null,
                    data: widget.qrGeneratedDTO!.qrCode,
                    version: QrVersions.auto,
                    embeddedImage:
                        const AssetImage('assets/images/ic-viet-qr-small.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(26, 26),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: Image.asset(
                        'assets/images/ic-napas247.png',
                        width: height < 800 ? width / 2 * 0.4 : width / 2 * 0.5,
                      ),
                    ),
                    if (widget.qrGeneratedDTO!.imgId.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 28),
                        child: Image(
                          image: ImageUtils.instance
                              .getImageNetWork(widget.qrGeneratedDTO!.imgId),
                          width: height < 800
                              ? (width / 2 * 0.5)
                              : (width / 2 * 0.6),
                          fit: BoxFit.fill,
                        ),
                      )
                    else
                      SizedBox(
                          width: height < 800
                              ? (width / 2 * 0.3)
                              : (width / 2 * 0.5)),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: AppColor.WHITE.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: Text(
                    '${widget.qrGeneratedDTO!.bankCode} Bank',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (isSmallWidget) ? 14 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 10),
                      child: VerticalDashedLine(),
                    )),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.qrGeneratedDTO!.bankAccount,
                      style: TextStyle(
                        fontSize: (isSmallWidget) ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      widget.qrGeneratedDTO!.userBankName,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                )),
                SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 4),
                      child: VerticalDashedLine(),
                    )),
                GestureDetector(
                  onTap: () async {
                    await FlutterClipboard.copy(ShareUtils.instance
                            .getTextSharing(widget.qrGeneratedDTO!))
                        .then(
                      (value) => Fluttertoast.showToast(
                        msg: 'Đã sao chép',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).cardColor,
                        textColor: Theme.of(context).hintColor,
                        fontSize: 15,
                        webBgColor: 'rgba(255, 255, 255)',
                        webPosition: 'center',
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/ic-copy-blue.png',
                    width: 32,
                  ),
                ),
                const SizedBox(
                  width: 8,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
