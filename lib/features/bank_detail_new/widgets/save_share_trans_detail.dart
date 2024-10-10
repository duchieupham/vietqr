import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/trans_list_dto.dart';

class SaveShareTransDetail extends StatefulWidget {
  final TypeImage type;
  final TransactionItemDetailDTO dto;
  const SaveShareTransDetail(
      {super.key, required this.type, required this.dto});

  @override
  State<SaveShareTransDetail> createState() => _SaveShareTransDetailState();
}

class _SaveShareTransDetailState extends State<SaveShareTransDetail> {
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
    bool isQr = widget.dto.transType == 'C' && widget.dto.type == 0;
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
                if (!isQr) _buildDetail(widget.dto) else _buildQr(widget.dto),
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

  Widget _buildQr(TransactionItemDetailDTO detail) {
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
                  detail.bankAccount,
                  style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
                ),
                const SizedBox(height: 2),
                Text(
                  detail.userBankName,
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
                  data: detail.qrCode,
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
                      detail.imgId.isNotEmpty
                          ? Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ImageUtils.instance
                                        .getImageNetWork(detail.imgId),
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
                const MySeparator(color: AppColor.GREY_DADADA),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                      text: detail.amount,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    detail.content,
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

  Widget _buildDetail(TransactionItemDetailDTO detail) {
    String amount = '${detail.transType == 'D' ? '-' : '+'} ${detail.amount}';
    Color color = AppColor.GREEN;
    String text = '';

    switch (detail.transType) {
      case "C":
        switch (detail.status) {
          case 0:
            // - Giao dịch chờ thanh toán
            color = AppColor.ORANGE_TRANS;
            text = 'Chờ thanh toán';
            break;
          case 1:
            switch (detail.type) {
              case 2:
                // - Giao dịch đến (+) không đối soát
                color = AppColor.BLUE_TEXT;
                text = 'Thanh toán thành công';
                break;
              default:
                // - Giao dịch đến (+) có đối soát
                color = AppColor.GREEN;
                text = 'Thanh toán thành công';
                break;
            }
            break;
          case 2:
            // Giao dịch hết hạn thanh toán;
            color = AppColor.GREY_TEXT;
            text = 'Hết hạn thanh toán';
            break;
        }
        break;
      case "D":
        // - Giao dịch đi (-)
        color = AppColor.RED_TEXT;
        text = 'Thanh toán thành công';
        break;
    }

    String transType = '';
    switch (detail.type) {
      case 0:
        transType = 'VietQR động';
        break;
      case 1:
        transType = 'VietQR tĩnh';
        break;
      case 2:
        transType = 'GD khác';
        break;
      case 3:
        transType = 'VietQR bán động';
        break;
      default:
        transType = 'GD khác';
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: AppColor.WHITE.withOpacity(0.6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.WHITE)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const XImage(
            imagePath: 'assets/images/ic-viet-qr.png',
            width: 85,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(
                  text: amount,
                  style: TextStyle(fontSize: 20, color: color),
                  children: const [
                TextSpan(
                  text: ' VND',
                  style: TextStyle(fontSize: 20, color: AppColor.GREY_TEXT),
                )
              ])),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 30),
          _buildItem(text: 'Mã GD:', value: detail.referenceNumber),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thời gian tạo',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('HH:mm:ss dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              detail.time * 1000)),
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  ],
                ),
                const VerticalDivider(color: AppColor.GREY_DADADA),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Thời gian TT',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('HH:mm:ss dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              detail.timePaid * 1000)),
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 10),
          _buildItem(
              text: 'Tài khoản:',
              value: '${detail.bankShortName} - ${detail.bankAccount}'),
          _buildItem(text: 'Chủ TK:', value: detail.userBankName),
          _buildItem(text: 'Loại GD:', value: transType),
          _buildItem(
              text: 'Mã đơn:',
              value: detail.orderId.isNotEmpty ? detail.orderId : '-'),
          _buildItem(
              text: 'Điểm bán:',
              value:
                  detail.terminalCode.isNotEmpty ? detail.terminalCode : '-'),
          _buildItem(
              text: 'Sản phẩm:',
              value: detail.serviceCode.isNotEmpty ? detail.serviceCode : '-'),
          const SizedBox(height: 10),
          const MySeparator(color: AppColor.GREY_DADADA),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nội dung TT:',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
                const SizedBox(height: 6),
                Text(
                  detail.content,
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem({
    required String text,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              textAlign: TextAlign.right,
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
