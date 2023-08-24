import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/features/scan_qr/views/dialog_feature_scan.dart';

class DialogScanOther extends StatelessWidget {
  final String code;
  final GestureTapCallback? onTapSave;

  DialogScanOther({super.key, required this.code, this.onTapSave});

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
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                child: QrImage(
                  data: code,
                  version: QrVersions.auto,
                ),
              );
            }),
        DialogFeatureWidget(
          dto: null,
          typeQR: TypeContact.Other,
          code: code,
          globalKey: globalKey,
        ),
      ],
    );
  }
}
