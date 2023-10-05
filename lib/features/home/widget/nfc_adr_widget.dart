import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

import 'nfc_widget.dart';

class NFCDialog extends StatefulWidget {
  @override
  State<NFCDialog> createState() => _NFCDialogState();
}

class _NFCDialogState extends State<NFCDialog> {
  NfcTag? tag;
  String message = 'Chạm thẻ NFC vào thiết bị của bạn để đọc dữ liệu.';
  String image = 'assets/images/sem-contato.png';
  bool isSuccess = false;

  Future<String?> handleTag(NfcTag tag) async {
    return 'Hoàn tất.';
  }

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      onDiscovered: (tag) async {
        try {
          final result = await handleTag(tag);
          if (result == null) return;
          await NfcManager.instance.stopSession();
          setState(() {
            message = result;
            isSuccess = true;
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context, true);
          });
        } catch (e) {
          await NfcManager.instance.stopSession();
          Navigator.pop(context, false);
        }
      },
    ).catchError((e) {});
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession().catchError((_) {});
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
                    Navigator.pop(context);
                  },
                )
              ] else
                const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}
