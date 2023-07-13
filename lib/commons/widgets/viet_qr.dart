import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class VietQr extends StatelessWidget {
  final QRGeneratedDTO qrGeneratedDTO;
  final bool? isSmallWidget;
  final String? content;

  const VietQr(
      {super.key,
      required this.qrGeneratedDTO,
      this.isSmallWidget = false,
      this.content});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.only(bottom: 40),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_napas_qr.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 24),
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Image.asset(
                    'assets/images/ic-viet-qr.png',
                    width: width * 0.22,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: QrImage(
                    data: qrGeneratedDTO.qrCode,
                    version: QrVersions.auto,
                    embeddedImage:
                        const AssetImage('assets/images/ic-viet-qr-small.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(30, 30),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Image.asset(
                        'assets/images/ic-napas247.png',
                        width: width / 2 * 0.5,
                      ),
                    ),
                    if (qrGeneratedDTO.imgId.isNotEmpty)
                      Image(
                        image: ImageUtils.instance
                            .getImageNetWork(qrGeneratedDTO.imgId),
                        width: width / 2 * 0.5,
                        fit: BoxFit.fill,
                      )
                    else
                      SizedBox(width: width / 2 * 0.5),
                  ],
                ),
                const SizedBox(height: 4),
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
          const SizedBox(height: 10),
          Column(
            children: [
              Text(
                qrGeneratedDTO.userBankName.toUpperCase(),
                style: TextStyle(
                  fontSize: (isSmallWidget != null && isSmallWidget!) ? 12 : 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                qrGeneratedDTO.bankAccount,
                style: TextStyle(
                  fontSize: (isSmallWidget != null && isSmallWidget!) ? 12 : 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                qrGeneratedDTO.bankName,
                style: TextStyle(
                  fontSize: (isSmallWidget != null && isSmallWidget!) ? 12 : 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (qrGeneratedDTO.content.isNotEmpty) ...[
            Text(
              qrGeneratedDTO.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: (isSmallWidget != null && isSmallWidget!) ? 12 : 15,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
