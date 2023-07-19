import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/create_qr/views/dialog_exits_view.dart';
import 'package:vierqr/features/create_qr/views/dialog_more_view.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class GeneratedQRView extends StatefulWidget {
  final QRGeneratedDTO? qrGeneratedDTO;
  final File? fileImage;
  final double progressBar;
  final Function(int) callback;

  const GeneratedQRView({
    super.key,
    required this.qrGeneratedDTO,
    this.fileImage,
    this.progressBar = 0,
    required this.callback,
  });

  @override
  State<GeneratedQRView> createState() => _GeneratedQRViewState();
}

class _GeneratedQRViewState extends State<GeneratedQRView> {
  final dto = const QRGeneratedDTO(
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: VietQr(qrGeneratedDTO: widget.qrGeneratedDTO ?? dto),
            ),
          ],
        ),
      ),
      bottomSheet: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MButtonWidget(
                      title: 'Đã thanh toán',
                      isEnable: true,
                      margin: const EdgeInsets.only(left: 20),
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (widget.fileImage != null) {
                        dialogExits();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(5)),
                      child: Image.asset(
                        'assets/images/ic-home-blue.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: dialog,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(5)),
                      child: Image.asset(
                        'assets/images/ic-more-blue.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (widget.fileImage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *
                          widget.progressBar,
                      alignment: Alignment.centerLeft,
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColor.BLUE_TEXT, width: 4),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                              widget.fileImage!,
                              height: 60,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Đang lưu tệp đính kèm.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  void dialog() async {
    final data = await showDialog(
      barrierDismissible: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return const DialogMoreView();
      },
    );

    if (data is int) {
      widget.callback(data);
    }
  }

  void dialogExits() async {
    final data = await showDialog(
      barrierDismissible: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return const DialogExitsView();
      },
    );

    if (data is int) {
      widget.callback(data);
    }
  }
}
