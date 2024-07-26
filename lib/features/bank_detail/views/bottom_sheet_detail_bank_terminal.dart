import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';
import 'package:vierqr/features/popup_bank/popup_bank_share.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';

class BottomSheetDetailBankBDSD extends StatelessWidget {
  final Function(String) onDelete;
  final TerminalBankResponseDTO dto;
  final bool hideRemove;

  const BottomSheetDetailBankBDSD({
    super.key,
    required this.dto,
    required this.onDelete,
    this.hideRemove = false,
  });

  @override
  Widget build(BuildContext context) {
    bool small = MediaQuery.of(context).size.height < 800;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const Spacer(),
              const SizedBox(
                width: 36,
              ),
              const Text(
                'Tài khoản chia sẻ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.clear,
                  size: 18,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Mã VietQR nhận biến động số dư theo nhóm.\nNhận tiền từ mọi ngân hàng và ví điện tử có hỗ trợ VietQR.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/images/bg-qr-vqr.png'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColor.GREY_BG,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: small ? 50 : 70,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                ImageUtils.instance.getImageNetWork(dto.imgId),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(
                        height: 40,
                        child: VerticalDashedLine(),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dto.bankAccount,
                                maxLines: 1,
                                style: TextStyle(
                                    color: AppColor.BLACK,
                                    fontSize: small ? 12 : 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dto.userBankName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColor.BLACK_TEXT,
                                  fontSize: small ? 10 : 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        child: VerticalDashedLine(),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          onCopy(dto, context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            'assets/images/ic-copy-blue.png',
                            width: small ? 24 : 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: QrImageView(
                                data: dto.qrCode,
                                size: 230,
                                version: QrVersions.auto,
                                embeddedImage: const AssetImage(
                                    'assets/images/ic-viet-qr-small.png'),
                                embeddedImageStyle: const QrEmbeddedImageStyle(
                                  size: Size(30, 30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: small ? 200 : 250,
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/logo_vietgr_payment.png',
                                height: 30),
                            Image.asset('assets/images/ic-napas247.png',
                                height: 30),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          _buildBottomBar(
            title: 'Lưu ảnh vào thư viện',
            showBorderTop: true,
            url: 'assets/images/ic-edit-avatar-setting.png',
            onTap: () => onSaveImage(context, dto),
          ),
          _buildBottomBar(
              title: 'Chia sẻ mã QR',
              url: 'assets/images/ic-share-blue.png',
              onTap: () => onShare(dto, context)),
          _buildBottomBar(
              title: 'Chi tiết',
              url: 'assets/images/ic-popup-bank-detail.png',
              onTap: () {
                NavigatorUtils.navigatePage(
                    context, BankCardDetailScreen(bankId: dto.bankId),
                    routeName: BankCardDetailScreen.routeName);
              }),
          if (!hideRemove)
            _buildBottomBar(
                title: 'Gỡ tài khoản chia sẻ',
                url: 'assets/images/ic-popup-bank-remove.png',
                color: AppColor.RED_TEXT,
                onTap: () {
                  Navigator.pop(context);
                  onDelete(dto.bankId);
                }),
        ],
      ),
    );
  }

  void onSaveImage(
      BuildContext context, TerminalBankResponseDTO bankAccountDTO) async {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: bankAccountDTO.bankCode,
      bankName: bankAccountDTO.bankName,
      bankAccount: bankAccountDTO.bankAccount,
      userBankName: bankAccountDTO.userBankName,
      qrCode: bankAccountDTO.qrCode,
      imgId: bankAccountDTO.imgId,
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SAVE),
        routeName: PopupBankShare.routeName);
  }

  void onCopy(
      TerminalBankResponseDTO bankAccountDTO, BuildContext context) async {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: bankAccountDTO.bankCode,
      bankName: bankAccountDTO.bankName,
      bankAccount: bankAccountDTO.bankAccount,
      userBankName: bankAccountDTO.userBankName,
      qrCode: bankAccountDTO.qrCode,
      imgId: bankAccountDTO.imgId,
    );

    await FlutterClipboard.copy(ShareUtils.instance.getTextSharing(dto))
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

  void onShare(TerminalBankResponseDTO bankAccountDTO, BuildContext context) {
    QRGeneratedDTO dto = QRGeneratedDTO(
      bankCode: bankAccountDTO.bankCode,
      bankName: bankAccountDTO.bankName,
      bankAccount: bankAccountDTO.bankAccount,
      userBankName: bankAccountDTO.userBankName,
      qrCode: bankAccountDTO.qrCode,
      imgId: bankAccountDTO.imgId,
    );
    NavigatorUtils.navigatePage(
        context, PopupBankShare(dto: dto, type: TypeImage.SHARE),
        routeName: PopupBankShare.routeName);
  }

  Widget _buildBottomBar({
    GestureTapCallback? onTap,
    required String url,
    required String title,
    Color? color,
    Color? colorIcon,
    bool showBorderTop = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.grey979797.withOpacity(0.4)),
              top: BorderSide(
                  color: showBorderTop
                      ? AppColor.grey979797.withOpacity(0.4)
                      : AppColor.WHITE)),
        ),
        child: Row(
          children: [
            Image.asset(
              url,
              width: 24,
              height: 36,
              color: colorIcon,
            ),
            Text(
              title,
              style: TextStyle(
                color: color ?? AppColor.BLUE_TEXT,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
