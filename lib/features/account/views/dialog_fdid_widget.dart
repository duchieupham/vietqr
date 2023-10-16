import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class FDIDDialog extends StatefulWidget {
  final String? data;
  final bool isScan;

  const FDIDDialog({super.key, this.data, this.isScan = false});

  @override
  State<FDIDDialog> createState() => _NFCDialogState();
}

class _NFCDialogState extends State<FDIDDialog> {
  NfcTag? tag;
  String message = 'Chạm thẻ NDID vào thiết bị của bạn để đọc dữ liệu.';
  String image = 'assets/images/sem-contato.png';
  bool isSuccess = false;
  static String cardScanTwo = 'Quét lần 2';

  String errorText = '';
  String cardNumber = '';
  String cardScan = '';

  Future<String?> handleTag(NfcTag tag) async {
    return 'Hoàn tất.';
  }

  @override
  void initState() {
    super.initState();
    onReadRFID();
  }

  void onReadRFID() async {
    RawKeyboard.instance.addListener(
      (RawKeyEvent event) async {
        String card = event.character ?? '';

        if (card.isEmpty) {
          setState(() {
            errorText = 'Thẻ không hợp lệ, vui lòng thử lại.';
          });
          RawKeyboard.instance.removeListener((value) {});
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.pop(context, {
              'error': errorText,
            });
          });
          return null;
        }

        if (widget.data != null) {
          if (widget.data == card) {
            setState(() {
              cardNumber = card;
            });
          }
        }

        if (widget.isScan) {
          cardScan = '';
        } else {
          cardScan = cardScanTwo;
        }
        setState(() {});

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pop(context, {
            'error': errorText,
            'cardScan': cardScan,
            'cardNumber': cardNumber,
            'isScan': widget.isScan,
          });
        });
      },
    );
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener((value) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isSuccess)
                Text(
                  'Sẵn sàng quét',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColor.grey979797,
                  ),
                ),
              const SizedBox(height: 12),
              if (isSuccess)
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: AppColor.BLUE_TEXT,
                  size: 100,
                )
              else
                Image.asset(
                  image,
                  width: 100,
                  height: 140,
                ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.textBlack,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: '$message\n'),
                  ],
                ),
              ),
              if (!isSuccess) ...[
                const SizedBox(height: 12),
                MButtonWidget(
                  title: 'Huỷ',
                  colorEnableText: AppColor.BLACK,
                  colorEnableBgr: AppColor.greyF1F2F5,
                  isEnable: true,
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                )
              ] else
                const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
