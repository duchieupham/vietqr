import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class VietQRWidget extends StatelessWidget {
  final double width;
  final QRGeneratedDTO qrGeneratedDTO;
  final String content;
  final bool? isStatistic;
  final bool? isCopy;
  final double? qrSize;
  final bool? isSmallWidget;

  const VietQRWidget({
    super.key,
    required this.width,
    required this.qrGeneratedDTO,
    required this.content,
    this.isStatistic,
    this.isCopy,
    this.qrSize,
    this.isSmallWidget,
  });

  @override
  Widget build(BuildContext context) {
    final double padding = (isSmallWidget != null && isSmallWidget!) ? 5 : 10;
    return BoxLayout(
      width: width - 40,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: (isSmallWidget != null && isSmallWidget!) ? 30 : 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                  image: (qrGeneratedDTO.imgId.isEmpty)
                      ? null
                      : DecorationImage(
                          image: ImageUtils.instance
                              .getImageNetWork(qrGeneratedDTO.imgId),
                        ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                child: Text(
                  qrGeneratedDTO.bankName,
                  style: TextStyle(
                    fontSize:
                        (isSmallWidget != null && isSmallWidget!) ? 12 : 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: padding)),
          DividerWidget(width: width),
          BoxLayout(
            width: (isSmallWidget != null && isSmallWidget!)
                ? width * 0.65
                : width * 0.7,
            height:
                (isSmallWidget != null && isSmallWidget!) ? width * 0.65 : null,
            enableShadow: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 20),
            bgColor: AppColor.WHITE,
            child: Column(
              children: [
                QrImage(
                  data: qrGeneratedDTO.qrCode,
                  version: QrVersions.auto,
                  size: (isSmallWidget != null && isSmallWidget!)
                      ? width * 0.5
                      : width * 0.6,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(30, 30),
                  ),
                ),
                SizedBox(
                  width: (isSmallWidget != null && isSmallWidget!)
                      ? width * 0.5
                      : width * 0.6,
                  height: (isSmallWidget != null && isSmallWidget!) ? 30 : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/ic-viet-qr.png',
                        width: width * 0.22,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.asset(
                          'assets/images/ic-napas247.png',
                          width: width * 0.22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (qrGeneratedDTO.amount.isNotEmpty &&
              qrGeneratedDTO.amount != '0') ...[
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            const Text(
              'Quét mã QR để thanh toán',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
              style: const TextStyle(
                color: AppColor.ORANGE,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          Padding(padding: EdgeInsets.only(bottom: padding)),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          _buildSection(
              title: 'Tài khoản: ', description: qrGeneratedDTO.bankAccount),
          Padding(padding: EdgeInsets.only(bottom: padding)),
          _buildSection(
            title: 'Chủ thẻ: ',
            description: qrGeneratedDTO.userBankName.toUpperCase(),
            isUnbold: true,
          ),
          Padding(padding: EdgeInsets.only(bottom: padding)),
          if (qrGeneratedDTO.content.isNotEmpty) ...[
            DividerWidget(width: width),
            Padding(padding: EdgeInsets.only(bottom: padding)),
            _buildSection(
              title: 'Nội dung: ',
              description: qrGeneratedDTO.content,
              isUnbold: true,
            ),
            Padding(padding: EdgeInsets.only(bottom: padding)),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    Color? descColor,
    bool? isUnbold,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: (isSmallWidget != null && isSmallWidget!) ? 12 : 15,
                ),
              ),
            ),
            Expanded(
              child: Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: (isSmallWidget != null && isSmallWidget!) ? 12 : 15,
                  fontWeight: (isUnbold != null && isUnbold)
                      ? FontWeight.normal
                      : FontWeight.w500,
                  color: descColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
