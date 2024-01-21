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
                    ? EdgeInsets.symmetric(horizontal: 40, vertical: 16)
                    : EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      decoration: BoxDecoration(
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
                      style: TextStyle(color: AppColor.WHITE),
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

  Widget _buildTypeQr(
      {TypeContact typeQR = TypeContact.NONE, required String name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(40),
              image: const DecorationImage(
                  image: AssetImage('assets/images/ic-viet-qr-small.png'),
                  fit: BoxFit.contain),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  typeQR.typeName,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Gradient getBgGradient(colorType) {
    switch (colorType) {
      case 0:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 1:
        return LinearGradient(
          colors: [
            const Color(0xFF52FBFF),
            const Color(0xFF06711B),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 2:
        return LinearGradient(
          colors: [
            const Color(0xFFEECDFF),
            const Color(0xFF49558A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 3:
        return LinearGradient(
          colors: [
            const Color(0xFFFBAE1F),
            const Color(0xFFFC6A01),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 4:
        return LinearGradient(
          colors: [
            const Color(0xFFFF6DC6),
            const Color(0xFFF8837A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [
            const Color(0xFF5FFFD8),
            const Color(0xFF0A7AFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
