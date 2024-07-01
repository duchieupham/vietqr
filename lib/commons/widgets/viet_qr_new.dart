import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/theme/bloc/theme_bloc.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:wakelock/wakelock.dart';

class VietQrNew extends StatefulWidget {
  final QRGeneratedDTO? qrGeneratedDTO;
  final String? qrCode;
  final String? content;
  final double? width;
  final double? height;

  const VietQrNew({
    super.key,
    this.qrGeneratedDTO,
    this.content,
    this.width,
    this.height,
    this.qrCode,
  });

  @override
  State<VietQrNew> createState() => _VietQrState();
}

class _VietQrState extends State<VietQrNew> {
  bool get small => MediaQuery.of(context).size.width < 400;
  final _themeBloc = getIt.get<ThemeBloc>();

  @override
  void initState() {
    super.initState();
    // Bật chế độ giữ màn hình sáng
    if (_themeBloc.state.settingDTO.keepScreenOn) {
      Wakelock.enable();
    }

    // setBrightness(1.0);
  }

  @override
  void dispose() {
    if (!mounted) return;
    // Tắt chế độ giữ màn hình sáng khi widget bị hủy

    Wakelock.disable();

    // resetBrightness();
    super.dispose();
  }

  double get paddingHorizontal => 45;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          QrImageView(
            data: widget.qrGeneratedDTO?.qrCode ?? widget.qrCode ?? '',
            size: widget.width ?? 250,
            version: QrVersions.auto,
            embeddedImage: const AssetImage(ImageConstant.icVietQrSmall),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(30, 30),
            ),
          ),
          Container(
            width: widget.width ?? 250,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                XImage(imagePath: ImageConstant.logoVietQRPayment, height: 30),
                XImage(imagePath: ImageConstant.icNapas247, height: 30),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
