import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/shimmer_block.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class QrWidget extends StatefulWidget {
  final QRGeneratedDTO dto;
  const QrWidget({super.key, required this.dto});

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 320,
      margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: AppColor.WHITE.withOpacity(opacity),
        gradient: LinearGradient(
          colors: [
            AppColor.WHITE.withOpacity(0.6),
            AppColor.WHITE,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColor.TRANSPARENT,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.dto.userBankName.isNotEmpty) ...[
                        Text(
                          widget.dto.userBankName,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.dto.bankAccount,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ]
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    FlutterClipboard.copy(
                            '${widget.dto.userBankName}\n${widget.dto.bankAccount}')
                        .then(
                      (value) => Fluttertoast.showToast(
                        msg: 'Đã sao chép',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).hintColor,
                        fontSize: 15,
                        webBgColor: 'rgba(255, 255, 255, 0.5)',
                        webPosition: 'center',
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColor.GREY_F0F4FA,
                    ),
                    child: const XImage(
                      imagePath: 'assets/images/ic-save-blue.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            width: 250,

            // child: PrettyQrView.data(
            //   data: widget.dto.qrCode,
            //   errorCorrectLevel: QrErrorCorrectLevel.M,
            //   decoration: PrettyQrDecoration(
            //       shape: PrettyQrSmoothSymbol(roundFactor: 1),
            //       image: PrettyQrDecorationImage(
            //           scale: 0.1,
            //           image: AssetImage('assets/images/ic-viet-qr-small.png'))),
            // ),

            child: QrImageView(
              padding: EdgeInsets.zero,
              data: widget.dto.qrCode,
              size: 80,
              version: QrVersions.auto,
              backgroundColor: AppColor.WHITE,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              embeddedImage:
                  const AssetImage('assets/images/ic-viet-qr-small.png'),
              dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColor.BLACK),
              eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square, color: AppColor.BLACK),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(30, 30),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
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
                Image.asset('assets/images/ic-napas247.png', height: 40),
                widget.dto.imgId.isNotEmpty
                    ? Container(
                        width: 80,
                        height: 40,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.instance
                                  .getImageNetWork(widget.dto.imgId),
                              fit: BoxFit.cover),
                        ),
                      )
                    : Container(
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
        ],
      ),
    );
  }
}

class QrLoadingWidget extends StatelessWidget {
  const QrLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 320,
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.WHITE,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerBlock(
                        height: 10,
                        width: 150,
                        borderRadius: 10,
                      ),
                      SizedBox(height: 4),
                      ShimmerBlock(
                        height: 10,
                        width: 120,
                        borderRadius: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(
            height: 250,
            width: 250,
            child: ShimmerBlock(
              height: 80,
              width: 80,
              borderRadius: 10,
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBlock(
                  height: 40,
                  width: 80,
                  borderRadius: 10,
                ),
                ShimmerBlock(
                  height: 40,
                  width: 80,
                  borderRadius: 10,
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
