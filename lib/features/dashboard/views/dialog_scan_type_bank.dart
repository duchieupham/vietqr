import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class DialogScanBank extends StatelessWidget {
  final QRGeneratedDTO dto;
  final GestureTapCallback? onTapSave;
  final GestureTapCallback? onTapAdd;

  const DialogScanBank(
      {super.key, required this.dto, this.onTapSave, this.onTapAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.WHITE,
      ),
      child: Column(
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: VietQr(qrGeneratedDTO: dto),
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Thêm TK ngân hàng',
            onTap: onTapAdd,
            isEnable: true,
            margin: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
          ),
          MButtonWidget(
            title: 'Lưu vào danh bạ',
            onTap: onTapSave,
            colorEnableBgr: AppColor.GREY_F1F2F5,
            colorEnableText: AppColor.BLUE_TEXT,
            isEnable: true,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          )
        ],
      ),
    );
  }
}
