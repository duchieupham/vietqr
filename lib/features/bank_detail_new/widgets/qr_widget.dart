import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class QrWidget extends StatelessWidget {
  final QRGeneratedDTO dto;
  const QrWidget({super.key, required this.dto});

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
                      Text(
                        dto.userBankName,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        dto.bankAccount,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    FlutterClipboard.copy(
                            '${dto.userBankName}\n${dto.bankAccount}')
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
          Container(
            height: 250,
            width: 250,
            child: QrImageView(
              padding: EdgeInsets.zero,
              data: dto.qrCode,
              size: 80,
              backgroundColor: AppColor.WHITE,
              embeddedImage:
                  const AssetImage('assets/images/ic-viet-qr-small.png'),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(30, 30),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30),
              // Image.asset(
              //     'assets/images/logo_vietgr_payment.png',
              //     height: 40),
              // Image.asset(
              //     'assets/images/ic-napas247.png',
              //     height: 40),
              Image.asset('assets/images/ic-napas247.png', height: 40),
              dto.imgId.isNotEmpty
                  ? Container(
                      width: 80,
                      height: 40,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                ImageUtils.instance.getImageNetWork(dto.imgId),
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
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
