import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_input_money.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:wakelock/wakelock.dart';

import '../utils/currency_utils.dart';
import 'dashed_line.dart';

class WidgetQr extends StatefulWidget {
  final QRGeneratedDTO qrGeneratedDTO;
  final String? content;
  final bool isVietQR;
  final String? qrCode;
  final double? size;
  final bool isEmbeddedImage;
  final Function(QRDetailBank) updateQRGeneratedDTO;

  const WidgetQr({
    super.key,
    required this.qrGeneratedDTO,
    this.content,
    this.isVietQR = false,
    this.isEmbeddedImage = false,
    this.qrCode,
    this.size,
    required this.updateQRGeneratedDTO,
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
    print('--------------------------$width');
    return Column(
      children: [
        Container(
          width: width,
          padding: height < 750
              ? const EdgeInsets.only(bottom: 12, left: 30, right: 30)
              : const EdgeInsets.only(bottom: 12, left: 30, right: 30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg-qr-vqr.png'),
                  fit: BoxFit.fitHeight),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Image(
                        image: ImageUtils.instance
                            .getImageNetWork(widget.qrGeneratedDTO!.imgId),
                        width: 60,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 10),
                          child: VerticalDashedLine(),
                        )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.qrGeneratedDTO.bankAccount,
                          style: TextStyle(
                            fontSize: (isSmallWidget) ? 14 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          widget.qrGeneratedDTO.userBankName,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )),
                    SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 4),
                          child: VerticalDashedLine(),
                        )),
                    GestureDetector(
                      onTap: () async {
                        await FlutterClipboard.copy(ShareUtils.instance
                                .getTextSharing(widget.qrGeneratedDTO))
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
              Container(
                margin: height < 750
                    ? const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 10)
                    : const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 12),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: QrImage(
                        size: height < 750 ? height / 3.5 : null,
                        data: widget.qrGeneratedDTO.qrCode,
                        version: QrVersions.auto,
                        embeddedImage: const AssetImage(
                            'assets/images/ic-viet-qr-small.png'),
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(26, 26),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Image.asset(
                            'assets/images/logo_vietgr_payment.png',
                            width: height < 800
                                ? width / 2 * 0.4
                                : width / 2 * 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Image.asset(
                            'assets/images/ic-napas247.png',
                            width: height < 800
                                ? width / 2 * 0.4
                                : width / 2 * 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              if (AppDataHelper.instance.checkExitsBankAccount(
                      widget.qrGeneratedDTO.bankAccount) &&
                  widget.qrGeneratedDTO.amount.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColor.WHITE),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${CurrencyUtils.instance.getCurrencyFormatted(widget.qrGeneratedDTO.amount)} VND',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () async {
                              QRDetailBank qRDetailBank = await DialogWidget
                                  .instance
                                  .showModelBottomSheet(
                                height: 370,
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 200),
                                borderRadius: BorderRadius.circular(16),
                                widget: BottomSheetInputMoney(
                                  dto: widget.qrGeneratedDTO,
                                ),
                              );
                              widget.updateQRGeneratedDTO(qRDetailBank);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Image.asset(
                                'assets/images/ic-edit-phone.png',
                                height: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                      if (widget.qrGeneratedDTO.content.isNotEmpty)
                        Text(
                          widget.qrGeneratedDTO.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.GREY_TEXT,
                          ),
                        )
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () async {
                    QRDetailBank qRDetailBank =
                        await DialogWidget.instance.showModelBottomSheet(
                      height: 370,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 200),
                      borderRadius: BorderRadius.circular(16),
                      widget: BottomSheetInputMoney(
                        dto: widget.qrGeneratedDTO,
                      ),
                    );
                    widget.updateQRGeneratedDTO(qRDetailBank);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColor.WHITE.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 18,
                          color: AppColor.BLUE_TEXT,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Thêm số tiền',
                          style: TextStyle(
                              color: AppColor.BLUE_TEXT, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Container(
          width: width,
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildButtonQR('assets/images/ic-save-img-blue.png',
                    width < 420 ? 'Lưu ảnh' : 'Lưu ảnh vào thư viện', () {}),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: _buildButtonQR('assets/images/ic-share-img-blue.png',
                    'Chia sẻ mã QR', () {}),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildButtonQR(String icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.BLUE_TEXT),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 30, width: 26, fit: BoxFit.cover),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
            )
          ],
        ),
      ),
    );
  }
}
