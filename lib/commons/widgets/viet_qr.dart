import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:wakelock/wakelock.dart';

class VietQr extends StatefulWidget {
  final QRGeneratedDTO? qrGeneratedDTO;
  final String? content;
  final bool isVietQR;
  final String? qrCode;
  final double? size;
  final bool isEmbeddedImage;

  const VietQr({
    super.key,
    required this.qrGeneratedDTO,
    this.content,
    this.isVietQR = false,
    this.isEmbeddedImage = false,
    this.qrCode,
    this.size,
  });

  @override
  State<VietQr> createState() => _VietQrState();
}

class _VietQrState extends State<VietQr> {
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

  // double currentBright = 0.0;
  //
  // Future<void> setBrightness(double brightness) async {
  //   try {
  //     currentBright = await ScreenBrightness().current;
  //     setState(() {});
  //     await ScreenBrightness().setScreenBrightness(brightness);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     throw 'Failed to set brightness';
  //   }
  // }
  //
  // Future<void> resetBrightness() async {
  //   try {
  //     await ScreenBrightness().setScreenBrightness(currentBright);
  //     await ScreenBrightness().resetScreenBrightness();
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     throw 'Failed to reset brightness';
  //   }
  // }

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
          ? const EdgeInsets.only(bottom: 16, left: 30, right: 30)
          : const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_napas_qr.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: height < 750
                ? const EdgeInsets.only(
                    left: 10, right: 10, top: 24, bottom: 10)
                : const EdgeInsets.only(left: 8, right: 8, top: 30, bottom: 24),
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
                    width: height < 750 ? width * 0.13 : width * 0.22,
                  ),
                ),
                if (height > 750) const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: QrImage(
                    size: height < 750 ? height / 3.5 : null,
                    data: widget.qrGeneratedDTO!.qrCode,
                    version: QrVersions.auto,
                    embeddedImage:
                        const AssetImage('assets/images/ic-viet-qr-small.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(30, 30),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Image.asset(
                        'assets/images/ic-napas247.png',
                        width: height < 800 ? width / 2 * 0.3 : width / 2 * 0.5,
                      ),
                    ),
                    if (widget.qrGeneratedDTO!.imgId.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Image(
                          image: ImageUtils.instance
                              .getImageNetWork(widget.qrGeneratedDTO!.imgId),
                          width: height < 800
                              ? (width / 2 * 0.3)
                              : (width / 2 * 0.5),
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
                if (height > 750) const SizedBox(height: 16),
              ],
            ),
          ),
          if (widget.qrGeneratedDTO!.amount.isNotEmpty &&
              widget.qrGeneratedDTO!.amount != '0') ...[
            Text(
              '${CurrencyUtils.instance.getCurrencyFormatted(widget.qrGeneratedDTO!.amount)} VND',
              style: const TextStyle(
                color: AppColor.ORANGE,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  widget.qrGeneratedDTO!.userBankName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (isSmallWidget) ? 12 : 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.qrGeneratedDTO!.bankAccount,
                  style: TextStyle(
                    fontSize: (isSmallWidget) ? 12 : 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.qrGeneratedDTO!.bankName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (isSmallWidget) ? 12 : 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (widget.qrGeneratedDTO!.content.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                widget.qrGeneratedDTO!.content,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: (isSmallWidget) ? 12 : 15,
                ),
              ),
            ),
          ],
        ],
      ),
    );
    // return FutureBuilder<double>(
    //   future: ScreenBrightness().current,
    //   builder: (context, snapshot) {
    //     double currentBrightness = 0;
    //     if (snapshot.hasData) {
    //       currentBrightness = snapshot.data!;
    //     }
    //
    //     return StreamBuilder<double>(
    //       stream: ScreenBrightness().onCurrentBrightnessChanged,
    //       builder: (context, snapshot) {
    //         double changedBrightness = currentBrightness;
    //         if (snapshot.hasData) {
    //           changedBrightness = snapshot.data!;
    //         }
    //
    //
    //       },
    //     );
    //   },
    // );
  }
}
