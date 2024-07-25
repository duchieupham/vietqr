import 'dart:math';

import 'package:flutter/material.dart';

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/scan_qr/views/dialog_feature_scan.dart';
import 'package:vierqr/models/contact_dto.dart';

class DialogScanTypeVCard extends StatelessWidget {
  final VCardModel dto;
  final TypeContact typeQR;
  final bool isShowIconFirst;

  DialogScanTypeVCard({
    super.key,
    required this.dto,
    required this.typeQR,
    this.isShowIconFirst = false,
  });

  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool isSmall = height < 800;

    final random = Random();

    int data = random.nextInt(5);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundaryWidget(
            globalKey: globalKey,
            builder: (key) {
              return Container(
                margin: isSmall
                    ? const EdgeInsets.symmetric(horizontal: 40, vertical: 16)
                    : const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: getBgGradient(data),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: isSmall
                          ? const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 15)
                          : const EdgeInsets.only(
                              left: 40, right: 40, top: 40, bottom: 40),
                      decoration: const BoxDecoration(
                        color: AppColor.WHITE,
                      ),
                      child: VietQr(
                        qrGeneratedDTO: null,
                        qrCode: dto.code,
                        isEmbeddedImage: true,
                        size: isSmall ? width / 2 : null,
                      ),
                    ),
                    Text(
                      dto.fullname ?? '',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.WHITE),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dto.phoneNo ?? '',
                      style: const TextStyle(color: AppColor.WHITE),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
          DialogFeatureWidget(
            dto: dto,
            typeQR: typeQR,
            code: dto.code,
            globalKey: globalKey,
            isSmall: isSmall,
            isShowIconFirst: isShowIconFirst,
          ),
        ],
      ),
    );
  }

  Gradient getBgGradient(colorType) {
    switch (colorType) {
      case 0:
        return const LinearGradient(
          colors: [
            Color(0xFF5FFFD8),
            Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 1:
        return const LinearGradient(
          colors: [
            Color(0xFF52FBFF),
            Color(0xFF06711B),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 2:
        return const LinearGradient(
          colors: [
            Color(0xFFEECDFF),
            Color(0xFF49558A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 3:
        return const LinearGradient(
          colors: [
            Color(0xFFFBAE1F),
            Color(0xFFFC6A01),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 4:
        return const LinearGradient(
          colors: [
            Color(0xFFFF6DC6),
            Color(0xFFF8837A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [
            Color(0xFF5FFFD8),
            Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
