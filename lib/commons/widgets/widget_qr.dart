import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_new.dart';
import 'package:vierqr/features/bank_card/widgets/custom_dot_paint.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_input_money.dart';
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/popup_bank/popup_bank_share.dart';
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
  bool get small => MediaQuery.of(context).size.height < 800;

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

    if (widget.qrGeneratedDTO.qrCode.isEmpty) return const SizedBox();
    print('--------------------------$width');
    return Column(
      children: [
        Container(
          width: width,
          padding: small
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
              SizedBox(height: small ? 24 : 32),
              Container(
                margin: EdgeInsets.symmetric(horizontal: small ? 16 : 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColor.GREY_BG,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: small ? 60 : 80,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ImageUtils.instance
                                .getImageNetWork(widget.qrGeneratedDTO.imgId),
                          ),
                        ),
                      ),
                      CustomPaint(
                          size: Size(1, double.infinity),
                          painter: DottedLinePainter(small ? 1.8 : 2)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.qrGeneratedDTO.bankAccount,
                                style: TextStyle(
                                    color: AppColor.BLACK,
                                    fontSize: small ? 12 : 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.qrGeneratedDTO.userBankName
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: AppColor.textBlack,
                                  fontSize: small ? 10 : 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.only(left: 12, right: 10),
                        child: VerticalDashedLine(),
                      ),
                      GestureDetector(
                        onTap: onCopy,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            'assets/images/ic-copy-blue.png',
                            width: small ? 24 : 36,
                            height: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              VietQrNew(
                qrCode: widget.qrGeneratedDTO.qrCode,
                paddingHorizontal: small ? 16 : 10,
              ),
              const SizedBox(height: 12),
              if (AppDataHelper.instance.checkExitsBankAccount(
                      widget.qrGeneratedDTO.bankAccount) &&
                  widget.qrGeneratedDTO.amount.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: small ? 4 : 8, horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: small ? 16 : 10),
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Image.asset(
                              'assets/images/ic-edit-phone.png',
                              color: Colors.transparent,
                              height: 30,
                            ),
                          ),
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
                    margin: EdgeInsets.symmetric(horizontal: small ? 16 : 10),
                    padding: EdgeInsets.symmetric(vertical: small ? 8 : 16),
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
                        const SizedBox(width: 4),
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                    width < 420 ? 'Lưu ảnh' : 'Lưu ảnh vào thư viện', () {
                  NavigatorUtils.navigatePage(
                      context,
                      PopupBankShare(
                          dto: widget.qrGeneratedDTO, type: TypeImage.SAVE),
                      routeName: PopupBankShare.routeName);
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButtonQR(
                    'assets/images/ic-share-img-blue.png', 'Chia sẻ mã QR', () {
                  NavigatorUtils.navigatePage(
                      context,
                      PopupBankShare(
                          dto: widget.qrGeneratedDTO, type: TypeImage.SHARE),
                      routeName: PopupBankShare.routeName);
                }),
              ),
            ],
          ),
        )
      ],
    );
  }

  void onCopy() async {
    await FlutterClipboard.copy(
            ShareUtils.instance.getTextSharing(widget.qrGeneratedDTO))
        .then((value) {
      Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Theme.of(context).hintColor,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      );
    });
  }

  Widget _buildButtonQR(String icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
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
