import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/separator_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';

class PopUpQrDetail extends StatefulWidget {
  final QrCreateFeedDTO dto;
  const PopUpQrDetail({super.key, required this.dto});

  @override
  State<PopUpQrDetail> createState() => _PopUpQrDetailState();
}

class _PopUpQrDetailState extends State<PopUpQrDetail> {
  @override
  Widget build(BuildContext context) {
    return _buildQrLink();
  }

  Widget _buildVCard() {
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
          _buildInfoRow('Số điện thoại', '098 883 1389', canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Tên liên hệ', 'Grammar Police 👮‍♂️', canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Email', '-'),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Website', '-'),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Tên công ty', '-'),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Địa chỉ', '-'),
        ],
      ),
    );
  }

  Widget _buildQrLink() {
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
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit',
                  style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: InkWell(
                  onTap: () {
                    FlutterClipboard.copy(
                            'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit')
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

  Widget _buildVietQr() {
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
          _buildInfoRow('Ngân hàng', 'MBBank', canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Số tài khoản', '1123355589', canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Chủ tài khoản', 'PHAM DUC HIEU', canSave: true),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Số tiền', '-'),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
          _buildInfoRow('Nội dung chuyển khoản',
              'Nội dung chuyển khoản Nội dung chuyển khoản Nội dung chuyển khoảnNội dung chuyển khoản',
              canSave: true),
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
