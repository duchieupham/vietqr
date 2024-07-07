import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/models/qr_feed_popup_detail_dto.dart';
import 'package:url_launcher/url_launcher.dart';

class PopUpQrDetail extends StatefulWidget {
  final QrFeedPopupDetailDTO dto;
  final String qrType;
  const PopUpQrDetail({super.key, required this.dto, required this.qrType});

  @override
  State<PopUpQrDetail> createState() => _PopUpQrDetailState();
}

class _PopUpQrDetailState extends State<PopUpQrDetail> {
  @override
  Widget build(BuildContext context) {
    return widget.qrType == '0'
        ? _buildQrLink(widget.dto)
        : widget.qrType == '1'
            ? _buildQrText(widget.dto)
            : widget.qrType == '2'
                ? _buildVCard(widget.dto)
                : _buildVietQr(widget.dto);
  }

  Widget _buildVCard(QrFeedPopupDetailDTO dto) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin mã QR VCard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildInfoRow('Số điện thoại', dto.phoneNo != '' ? dto.phoneNo! : '-',
              canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Tên liên hệ', dto.fullName != '' ? dto.fullName! : '-',
              canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
            'Email',
            dto.email != '' ? dto.email! : '-',
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
            'Website',
            dto.website != '' ? dto.website! : '-',
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
            'Tên công ty',
            dto.companyName != '' ? dto.companyName! : '-',
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
            'Địa chỉ',
            dto.address != '' ? dto.address! : '-',
          ),
        ],
      ),
    );
  }

  Widget _buildQrText(QrFeedPopupDetailDTO dto) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin QR Text',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Nội dung',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  dto.value!,
                  style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: InkWell(
                  onTap: () {
                    FlutterClipboard.copy(dto.value!).then(
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
                        imagePath: 'assets/images/ic-save-blue.png'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrLink(QrFeedPopupDetailDTO dto) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin QR đường dẫn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Đường dẫn',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () async {
                    if (dto.value != null) {
                      final url = dto.value!;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // Handle the error by showing a message to the user
                        print('Could not launch $url');
                      }
                    }
                  },
                  child: Text(
                    dto.value!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.BLUE_TEXT,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.BLUE_TEXT,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: InkWell(
                  onTap: () {
                    FlutterClipboard.copy(dto.value!).then(
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
                        imagePath: 'assets/images/ic-save-blue.png'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVietQr(QrFeedPopupDetailDTO dto) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông tin mã VietQR',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.clear,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildInfoRow('Ngân hàng', dto.bankCode != '' ? dto.bankCode! : '-',
              canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
              'Số tài khoản', dto.bankAccount != '' ? dto.bankAccount! : '-',
              canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
              'Chủ tài khoản', dto.userBankName != '' ? dto.userBankName! : '-',
              canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
            'Số tiền',
            dto.amount != ''
                ? '${CurrencyUtils.instance.getCurrencyFormatted(dto.amount!)} VND'
                : '-',
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow(
              'Nội dung chuyển khoản', dto.content != '' ? dto.content! : '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool canSave = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.end, // Đặt textAlign là end để căn lề phải
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Visibility(
              visible: canSave,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () {
                    FlutterClipboard.copy(value).then(
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
                        imagePath: 'assets/images/ic-save-blue.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
