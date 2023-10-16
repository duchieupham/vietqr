import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

class RFIDDialog extends StatefulWidget {
  final String? data;
  final bool isScan;

  const RFIDDialog({super.key, this.data, this.isScan = false});

  @override
  State<RFIDDialog> createState() => _NFCDialogState();
}

class _NFCDialogState extends State<RFIDDialog> {
  NfcTag? tag;
  String message = 'Chạm thẻ RFID vào thiết bị của bạn để đọc dữ liệu.';
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

  String card = '';

  void onReadRFID() async {
    RawKeyboard.instance.addListener(
      (RawKeyEvent event) async {
        card += event.character ?? '';

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
    final double width = MediaQuery.of(context).size.width;
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
            children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              SizedBox(
                width: width,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 25)),
                    const Spacer(),
                    const Text(
                      'VietQR ID Card',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).canvasColor.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 50)),
              Image.asset(
                'assets/images/ic-card-nfc.png',
                width: 200,
                height: 200,
              ),
              const Text(
                'Quét thẻ VietQR ID để đăng nhập',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
