import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class SaveShareQr extends StatefulWidget {
  final TypeImage type;
  final QRGeneratedDTO qrDto;
  const SaveShareQr({super.key, required this.type, required this.qrDto});

  @override
  State<SaveShareQr> createState() => _SaveShareQrState();
}

class _SaveShareQrState extends State<SaveShareQr> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 2000),
      () async {
        if (widget.type == TypeImage.SAVE) {
          onSaveImage(context);
        } else if (widget.type == TypeImage.SHARE) {
          share();
        }
      },
    );
  }

  void share() async {
    await ShareUtils.instance
        .shareImage(key: globalKey, textSharing: '')
        .then((value) {
      Navigator.pop(context);
    });
  }

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 2000),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.WHITE,
      child: RepaintBoundaryWidget(
        globalKey: globalKey,
        builder: (key) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              gradient: VietQRTheme.gradientColor.lilyLinear,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 12),
                _buildQr(),
                const Text(
                  'BY VIETQR.VN',
                  style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQr() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const XImage(
            imagePath: 'assets/images/logo_vietgr_payment.png',
            height: 40,
            width: 100,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.fromLTRB(50, 24, 50, 24),
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColor.WHITE.withOpacity(0.6),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.WHITE)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.qrDto.bankAccount,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.qrDto.userBankName,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.BLACK,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const MySeparator(color: AppColor.GREY_DADADA),
                const SizedBox(height: 15),
                QrImageView(
                  padding: EdgeInsets.zero,
                  data: widget.qrDto.qrCode,
                  size: 250,
                  version: QrVersions.auto,
                  backgroundColor: AppColor.TRANSPARENT,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                  // embeddedImage:
                  //     const AssetImage('assets/images/ic-viet-qr-small.png'),
                  dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColor.BLACK),
                  eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square, color: AppColor.BLACK),
                  // embeddedImageStyle: const QrEmbeddedImageStyle(
                  //   size: Size(30, 30),
                  // ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const SizedBox(width: 30),
                      // Image.asset(
                      //     'assets/images/logo_vietgr_payment.png',
                      //     height: 40),
                      // Image.asset(
                      //     'assets/images/ic-napas247.png',
                      //     height: 40),
                      const XImage(
                        imagePath: 'assets/images/logo-napas-trans-bgr.png',
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
                      widget.qrDto.imgId.isNotEmpty
                          ? Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ImageUtils.instance
                                        .getImageNetWork(widget.qrDto.imgId),
                                    fit: BoxFit.fitHeight),
                              ),
                            )
                          : SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset(
                                  'assets/images/logo_vietgr_payment.png',
                                  height: 40),
                            ),
                      // const SizedBox(width: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.qrDto.amount.isNotEmpty ||
                    widget.qrDto.content.isNotEmpty) ...[
                  const MySeparator(color: AppColor.GREY_DADADA),
                  const SizedBox(height: 20),
                ] else
                  const SizedBox(height: 20),
                if (widget.qrDto.amount.isNotEmpty) ...[
                  RichText(
                    text: TextSpan(
                        text: CurrencyUtils.instance
                            .getCurrencyFormatted(widget.qrDto.amount),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColor.ORANGE_TRANS,
                        ),
                        children: const [
                          TextSpan(
                              text: '   VND',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT))
                        ]),
                  ),
                  const SizedBox(height: 15),
                ],
                if (widget.qrDto.content.isNotEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      widget.qrDto.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
