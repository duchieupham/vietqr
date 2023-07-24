import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button_widget.dart';

class DialogMyQR extends StatelessWidget {
  final String code;
  final String userName;
  final GestureTapCallback? onTapShare;

  const DialogMyQR({
    super.key,
    required this.code,
    this.onTapShare,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
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
                            'My QR',
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
                const SizedBox(height: 60),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColor.WHITE,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: QrImage(
                    data: code,
                    version: QrVersions.auto,
                    embeddedImage:
                        const AssetImage('assets/images/ic-viet-qr-small.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: const Size(30, 30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 100),
                MButtonWidget(
                  title: 'Chia sẻ',
                  onTap: onTapShare,
                  isEnable: true,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
