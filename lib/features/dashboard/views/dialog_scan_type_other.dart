import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button_widget.dart';

class DialogScanOther extends StatelessWidget {
  final String code;
  final GestureTapCallback? onTapSave;

  const DialogScanOther({super.key, required this.code, this.onTapSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.WHITE,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.clear, color: Colors.transparent, size: 20),
                const Expanded(
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.BLACK,
                    ),
                    child: Text(
                      'Mã QR',
                    ),
                  ),
                ),
                GestureDetector(
                  child: const Icon(Icons.clear, size: 20),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColor.WHITE,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: QrImage(
              data: code,
              version: QrVersions.auto,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loại QR không xác định',
            style: TextStyle(
              color: AppColor.BLACK,
            ),
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Lưu vào danh bạ',
            onTap: onTapSave,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            isEnable: true,
          ),
        ],
      ),
    );
  }
}
