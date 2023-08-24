import 'package:flutter/material.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/scan_qr/views/dialog_feature_scan.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class DialogScanBank extends StatelessWidget {
  final QRGeneratedDTO dto;
  final GestureTapCallback? onTapSave;
  final GestureTapCallback? onTapAdd;

  DialogScanBank({super.key, required this.dto, this.onTapSave, this.onTapAdd});

  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundaryWidget(
          globalKey: globalKey,
          builder: (key) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: VietQr(qrGeneratedDTO: dto),
            );
          },
        ),
        DialogFeatureWidget(
          dto: dto,
          typeQR: TypeContact.Bank,
          code: dto.qrCode,
          globalKey: globalKey,
        ),
      ],
    );
  }
}
