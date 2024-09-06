import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class PopupInfoQr extends StatelessWidget {
  final ValueNotifier<bool> hoverNotifier;
  const PopupInfoQr({super.key, required this.hoverNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: hoverNotifier,
      builder: (context, value, child) {
        if (!value) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.only(left: 30, right: 50),
          child: ClipPath(
            clipper: LowerNipMessageClipper(MessageType.send, bubbleRadius: 10),
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: AppColor.WHITE,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quét mã VietQR:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => VietQRTheme
                        .gradientColor.brightBlueLinear
                        .createShader(bounds),
                    child: Center(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          RotateAnimatedText(
                              'Hỗ trợ quét mã VietQR các ngân hàng',
                              duration: const Duration(seconds: 2),
                              rotateOut: true,
                              textAlign: TextAlign.center,
                              textStyle: const TextStyle(
                                color: AppColor.WHITE,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          RotateAnimatedText('Hỗ trợ quét mã QR VCard',
                              duration: const Duration(seconds: 2),
                              rotateOut: true,
                              textAlign: TextAlign.center,
                              textStyle: const TextStyle(
                                color: AppColor.WHITE,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          RotateAnimatedText('Hỗ trợ quét mã QR Link',
                              duration: const Duration(seconds: 2),
                              rotateOut: true,
                              textAlign: TextAlign.center,
                              textStyle: const TextStyle(
                                color: AppColor.WHITE,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          RotateAnimatedText('Hỗ trợ quét mã QR active key',
                              duration: const Duration(seconds: 2),
                              rotateOut: true,
                              textAlign: TextAlign.center,
                              textStyle: const TextStyle(
                                color: AppColor.WHITE,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          RotateAnimatedText(
                              'Hỗ trợ quét mã QR Wordpress Plugin',
                              duration: const Duration(seconds: 2),
                              rotateOut: true,
                              textAlign: TextAlign.center,
                              textStyle: const TextStyle(
                                color: AppColor.WHITE,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
