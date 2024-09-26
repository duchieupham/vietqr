// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/scan_qr/views/dialog_feature_scan.dart';

class DialogScanURL extends StatelessWidget {
  final String code;
  final GestureTapCallback? onTapSave;
  final bool isShowIconFirst;

  DialogScanURL({
    super.key,
    required this.code,
    this.onTapSave,
    this.isShowIconFirst = false,
  });

  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundaryWidget(
            globalKey: globalKey,
            builder: (key) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColor.WHITE,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: VietQr(
                  qrGeneratedDTO: null,
                  qrCode: code,
                  isEmbeddedImage: true,
                ),
              );
            }),
        DialogFeatureWidget(
          dto: null,
          typeQR: TypeContact.Other,
          code: code,
          type: TypeQR.QR_LINK,
          globalKey: globalKey,
          isShowIconFirst: isShowIconFirst,
        ),
      ],
    );
  }
}
