import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class VietQr extends StatelessWidget {
  final QRGeneratedDTO qrGeneratedDTO;
  final String? content;

  const VietQr({super.key, required this.qrGeneratedDTO, this.content});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    bool isSmallWidget = height < 800;
    return Container(
      width: width,
      margin: height < 800
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(vertical: 8),
      padding: height < 800
          ? const EdgeInsets.only(bottom: 16, left: 20, right: 20)
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
            margin: height < 800
                ? const EdgeInsets.only(left: 8, right: 8, top: 24, bottom: 20)
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
                    width: height < 800 ? width * 0.15 : width * 0.22,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: QrImage(
                    size: height < 800 ? width / 2 : null,
                    // data: qrGeneratedDTO.qrCode,
                    data:
                        'BEGIN:VCARD\r\nVERSION:3.0\r\nN;CHARSET=UTF-8:Phạm;Đức;Tuấn;\r\nFN;CHARSET=UTF-8:Phạm Đức Tuấn\r\nORG;CHARSET=UTF-8:BLUECOM\r\nTITLE:\r\nTEL;TYPE=WORK,VOICE:\r\nTEL;TYPE=CELL,VOICE:0936382222\r\nTEL;TYPE=CELL,VOICE:\r\nTEL;TYPE=CELL,VOICE:\r\nTEL;TYPE=FAX,WORK,VOICE:\r\nADR;CHARSET=UTF-8;TYPE=HOME:;;Hà Nội;;;;\r\nLABEL;CHARSET=UTF-8;TYPE=HOME:Hà Nội\r\n,\r\nEMAIL;TYPE=PREF,internet:tuan@bluecom.vn\r\nEMAIL;TYPE=WORK,internet:\r\nURL:https://www.google.com.vn\r\nURL:\r\nURL:\r\nREV:2023-10-03T10:50:43Z\r\nEND:VCARD',
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
                    if (qrGeneratedDTO.imgId.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Image(
                          image: ImageUtils.instance
                              .getImageNetWork(qrGeneratedDTO.imgId),
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
                const SizedBox(height: 16),
              ],
            ),
          ),
          if (qrGeneratedDTO.amount.isNotEmpty &&
              qrGeneratedDTO.amount != '0') ...[
            Text(
              '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
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
                  qrGeneratedDTO.userBankName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (isSmallWidget) ? 12 : 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  qrGeneratedDTO.bankAccount,
                  style: TextStyle(
                    fontSize: (isSmallWidget) ? 12 : 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  qrGeneratedDTO.bankName,
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
          if (qrGeneratedDTO.content.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                qrGeneratedDTO.content,
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
  }
}
