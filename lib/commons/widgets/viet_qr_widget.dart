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
  final double? height;
  final QRGeneratedDTO qrGeneratedDTO;
  final String content;
  final bool? isStatistic;
  final bool? isCopy;
  final double? qrSize;

  const VietQRWidget({
    super.key,
    required this.width,
    required this.qrGeneratedDTO,
    required this.content,
    this.height,
    this.isStatistic,
    this.isCopy,
    this.qrSize,
  });

  @override
  Widget build(BuildContext context) {
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
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: DefaultTheme.WHITE,
                  image: DecorationImage(
                    image: ImageUtils.instance
                        .getImageNetWork(qrGeneratedDTO.imgId),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Expanded(
                child: Text(
                  qrGeneratedDTO.bankName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          DividerWidget(width: width),
          BoxLayout(
            width: width * 0.7,
            enableShadow: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 20),
            bgColor: DefaultTheme.WHITE,
            child: Column(
              children: [
                QrImage(
                  data: qrGeneratedDTO.qrCode,
                  version: QrVersions.auto,
                  size: width * 0.6,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(30, 30),
                  ),
                ),
                SizedBox(
                  width: width * 0.6,
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
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          _buildSection(
              title: 'Tài khoản: ', description: qrGeneratedDTO.bankAccount),
          const Padding(padding: EdgeInsets.only(bottom: 5)),
          _buildSection(
              title: 'Chủ thẻ: ', description: qrGeneratedDTO.userBankName),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          if (qrGeneratedDTO.amount.isNotEmpty &&
              qrGeneratedDTO.amount != '0') ...[
            DividerWidget(width: width),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            _buildSection(
              title: 'Số tiền: ',
              description:
                  '${CurrencyUtils.instance.getCurrencyFormatted(qrGeneratedDTO.amount)} VND',
              descColor: DefaultTheme.GREEN,
            ),
          ],
          if (qrGeneratedDTO.content.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            _buildSection(
              title: 'Nội dung: ',
              description: qrGeneratedDTO.content,
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        ],
      ),
    );
    // return Container(
    //   width: width,
    //   alignment: Alignment.center,
    //   decoration: BoxDecoration(
    //     color: Theme.of(context).cardColor,
    //     borderRadius: BorderRadius.circular(5),
    //   ),
    //   child: (isCopy != null && isCopy!)
    //       ? Stack(
    //           fit: StackFit.expand,
    //           children: [
    //             _buildComponent(context),
    //             Positioned(
    //               right: 10,
    //               top: 10,
    //               child: InkWell(
    //                 onTap: () async {
    //                   await FlutterClipboard.copy(getTextSharing()).then(
    //                     (value) => Fluttertoast.showToast(
    //                       msg: 'Đã sao chép',
    //                       toastLength: Toast.LENGTH_SHORT,
    //                       gravity: ToastGravity.CENTER,
    //                       timeInSecForIosWeb: 1,
    //                       backgroundColor: Theme.of(context).primaryColor,
    //                       textColor: Theme.of(context).hintColor,
    //                       fontSize: 15,
    //                       webBgColor: 'rgba(255, 255, 255)',
    //                       webPosition: 'center',
    //                     ),
    //                   );
    //                 },
    //                 child: const Icon(
    //                   Icons.copy_outlined,
    //                   color: DefaultTheme.GREY_TOP_TAB_BAR,
    //                   size: 20,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         )
    //       : _buildComponent(context),
    // );
  }

  Widget _buildSection({
    required String title,
    required String description,
    Color? descColor,
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
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: descColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponent(BuildContext context) {
    // return RepaintBoundaryWidget(
    //   globalKey: globalKey,
    //   builder: (key) {
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    ImageUtils.instance.getImageNetWork(qrGeneratedDTO.imgId),
              ),
            ),
          ),
          SizedBox(
            width: width,
            child: Text(
              qrGeneratedDTO.bankName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          SizedBox(
            width: width * 0.9,
            child: Text(
              '${qrGeneratedDTO.bankAccount} - ${qrGeneratedDTO.userBankName.toUpperCase()}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          BoxLayout(
            width: (qrSize != null) ? (qrSize! + 10) : 210,
            borderRadius: 5,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            bgColor: DefaultTheme.WHITE,
            enableShadow: true,
            child: Column(
              children: [
                QrImage(
                  data: qrGeneratedDTO.qrCode,
                  version: QrVersions.auto,
                  size: (qrSize != null) ? qrSize : 200,
                  embeddedImage:
                      const AssetImage('assets/images/ic-viet-qr-small.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: (qrSize != null)
                        ? Size(qrSize! / 8, qrSize! / 8)
                        : const Size(25, 25),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'assets/images/ic-viet-qr.png',
                        width: (qrSize != null) ? (qrSize! / 3 - 5) : 75,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Image.asset(
                          'assets/images/ic-napas247.png',
                          width: (qrSize != null) ? (qrSize! / 3 - 5) : 75,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            ),
          ),
          (qrGeneratedDTO.amount != '' && qrGeneratedDTO.amount != '0')
              ? const Padding(padding: EdgeInsets.only(top: 30))
              : const SizedBox(),
          (qrGeneratedDTO.amount != '' && qrGeneratedDTO.amount != '0')
              ? RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: DefaultTheme.GREEN,
                    ),
                    children: [
                      TextSpan(
                        text: CurrencyUtils.instance
                            .getCurrencyFormatted(qrGeneratedDTO.amount),
                      ),
                      TextSpan(
                        text: ' VND',
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          const Padding(
            padding: EdgeInsets.only(top: 5),
          ),
          (content != '')
              ? SizedBox(
                  width: width * 0.9,
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: DefaultTheme.GREEN,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
    //   },
    // );
  }

  String getTextSharing() {
    String result = '';

    if (qrGeneratedDTO.amount != '' && qrGeneratedDTO.amount != '0') {
      if (content != '') {
        result =
            '${qrGeneratedDTO.bankAccount} - ${qrGeneratedDTO.bankName}\nSố tiền: ${qrGeneratedDTO.amount}\nNội dung: $content';
      } else {
        result =
            '${qrGeneratedDTO.bankAccount} - ${qrGeneratedDTO.bankName}\nSố tiền: ${qrGeneratedDTO.amount}';
      }
    } else {
      if (content != '') {
        result =
            '${qrGeneratedDTO.bankAccount} - ${qrGeneratedDTO.bankName}\nNội dung: $content';
      } else {
        result = '${qrGeneratedDTO.bankAccount} - ${qrGeneratedDTO.bankName}';
      }
    }

    return result.trim();
  }
}
