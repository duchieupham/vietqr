import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class BottomBarWidget extends StatelessWidget {
  BottomBarWidget({
    super.key,
    required this.width,
    required this.selectTab,
    required this.onSave,
    required this.onShare,
  });

  final double width;
  final int selectTab;
  final VoidCallback onSave;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        width: width,
        color: AppColor.WHITE.withOpacity(0.6),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (selectTab == 0) ...[
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF00C6FF),
                                Color(0xFF0072FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              XImage(
                                imagePath:
                                    'assets/images/qr-contact-other-white.png',
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                'Tạo QR giao dịch',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        onSave();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                                colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: const XImage(
                            imagePath: 'assets/images/ic-dowload.png'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        onShare();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                                colors: [Color(0xFFE1EFFF), Color(0xFFE5F9FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight)),
                        child: const XImage(
                            imagePath: 'assets/images/ic-share-black.png'),
                      ),
                    ),
                  ] else if (selectTab == 1)
                    ...[]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
