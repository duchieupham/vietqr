import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
// import 'package:vierqr/layouts/image/x_image.dart';

class SaveShareQrWidget extends StatefulWidget {
  final String title;
  final String data;
  final String fileAttachmentId;
  final String value;
  final String qrType;
  final TypeImage type;
  const SaveShareQrWidget({
    super.key,
    required this.title,
    required this.data,
    required this.fileAttachmentId,
    required this.value,
    required this.qrType,
    required this.type,
  });

  @override
  State<SaveShareQrWidget> createState() => _SaveShareQrWidgetState();
}

class _SaveShareQrWidgetState extends State<SaveShareQrWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 2000),
      () async {
        if (widget.type == TypeImage.SAVE) {
          onSaveImage(context);
        } else if (widget.type == TypeImage.SHARE) {
          share();
        }
      },
    );
  }

  void share() async {
    await ShareUtils.instance
        .shareImage(key: globalKey, textSharing: '')
        .then((value) {
      Navigator.pop(context);
    });
  }

  final globalKey = GlobalKey();
  final List<List<Color>> _gradients = [
    [const Color(0xFFE1EFFF), const Color(0xFFE5F9FF)],
    [const Color(0xFFBAFFBF), const Color(0xFFCFF4D2)],
    [const Color(0xFFFFC889), const Color(0xFFFFDCA2)],
    [const Color(0xFFA6C5FF), const Color(0xFFC5CDFF)],
    [const Color(0xFFCDB3D4), const Color(0xFFF7C1D4)],
    [const Color(0xFFF5CEC7), const Color(0xFFFFD7BF)],
    [const Color(0xFFBFF6FF), const Color(0xFFFFDBE7)],
    [const Color(0xFFF1C9FF), const Color(0xFFFFB5AC)],
    [const Color(0xFFB4FFEE), const Color(0xFFEDFF96)],
    [const Color(0xFF91E2FF), const Color(0xFF91FFFF)],
  ];

  void onSaveImage(BuildContext context) async {
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(
      const Duration(milliseconds: 2000),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Navigator.pop(context);
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String qrType1 = '';
    switch (widget.qrType) {
      case '0':
        qrType1 = 'QR đường dẫn';
        break;
      case '1':
        qrType1 = 'QR khác';
        break;
      case '2':
        qrType1 = 'VCard';
        break;
      case '3':
        qrType1 = 'VietQR';

        break;
      default:
    }
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      color: AppColor.WHITE,
      child: Column(
        children: [
          RepaintBoundaryWidget(
            globalKey: globalKey,
            builder: (key) {
              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: _gradients[0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                ),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(40, 200, 40, 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.WHITE,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DefaultTextStyle(
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.BLACK),
                                child: Text(widget.title),
                              ),
                              DefaultTextStyle(
                                style: const TextStyle(
                                    fontSize: 12, color: AppColor.BLACK),
                                child: Text(widget.data),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 250,
                          width: 250,
                          margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: QrImageView(
                            padding: EdgeInsets.zero,
                            data: widget.value,
                            size: 80,
                            backgroundColor: AppColor.WHITE,
                            embeddedImage: ImageUtils.instance
                                .getImageNetworkCache(widget.fileAttachmentId),
                            embeddedImageStyle: const QrEmbeddedImageStyle(
                              size: Size(50, 50),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                  fontSize: 10, color: AppColor.GREY_TEXT),
                              child: Text(
                                '$qrType1   |   By VIETQR.VN',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
