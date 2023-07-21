import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class DialogScanBank extends StatelessWidget {
  final QRGeneratedDTO dto;

  const DialogScanBank({super.key, required this.dto});

  final _dto = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.90,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                      const Icon(Icons.clear,
                          color: Colors.transparent, size: 20),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: VietQr(qrGeneratedDTO: dto),
                  ),
                ),
                const SizedBox(height: 30),
                MButtonWidget(
                  title: 'Thêm TK ngân hàng',
                  onTap: () {},
                  isEnable: true,
                ),
                MButtonWidget(
                  title: 'Lưu vào danh bạ',
                  onTap: () {},
                  isEnable: true,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
