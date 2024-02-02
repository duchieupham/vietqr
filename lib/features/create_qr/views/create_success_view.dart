import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/features/create_qr/widgets/dialog_exits_view.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

class CreateQRSuccess extends StatefulWidget {
  final QRGeneratedDTO dto;
  final GestureTapCallback? onPaid;

  CreateQRSuccess({super.key, required this.dto, this.onPaid});

  @override
  State<CreateQRSuccess> createState() => _CreateQRSuccessState();
}

class _CreateQRSuccessState extends State<CreateQRSuccess> {
  final GlobalKey globalKey = GlobalKey();

  final _waterMarkProvider = WaterMarkProvider(false);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColor.GREY_BG,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              RepaintBoundaryWidget(
                  globalKey: globalKey,
                  builder: (key) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: VietQr(qrGeneratedDTO: widget.dto, isVietQR: true),
                    );
                  }),
              ValueListenableBuilder(
                valueListenable: _waterMarkProvider,
                builder: (_, provider, child) {
                  return Visibility(
                    visible: provider == true,
                    child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: const TextSpan(
                          style: TextStyle(
                            color: AppColor.GREY_TEXT,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: 'Được tạo bởi '),
                            TextSpan(
                              text: 'vietqr.vn',
                              style: TextStyle(
                                color: AppColor.BLUE_TEXT,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(text: ' - '),
                            TextSpan(text: 'Hotline '),
                            TextSpan(
                              text: '19006234',
                              style: TextStyle(
                                color: AppColor.BLUE_TEXT,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Consumer<CreateQRProvider>(
        builder: (context, bt, child) {
          return _buildButton(
              context: context,
              fileImage: bt.imageFile,
              progressBar: bt.progressBar,
              onClick: (index) {
                onClick(index, widget.dto);
              },
              onCreate: () {
                bt.reset();
                bt.updatePage(0);
              },
              onPaid: widget.onPaid);
        },
      ),
    );
  }

  Widget _buildButton({
    File? fileImage,
    double progressBar = 0,
    required BuildContext context,
    GestureTapCallback? onPaid,
    required Function(int) onClick,
    required Function() onCreate,
  }) {
    double width = MediaQuery.of(context).size.width;
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      pathIcon: 'assets/images/ic-print-blue.png',
                      title: '',
                      function: () async {
                        onClick(0);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.ORANGE,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      pathIcon: 'assets/images/ic-img-blue.png',
                      title: '',
                      function: () {
                        onClick(1);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.RED_CALENDAR,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      pathIcon: 'assets/images/ic-copy-blue.png',
                      title: '',
                      function: () async {
                        onClick(2);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.BLUE_TEXT,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    ButtonIconWidget(
                      width: width * 0.2,
                      height: 40,
                      pathIcon: 'assets/images/ic-share-blue.png',
                      title: '',
                      function: () {
                        onClick(3);
                      },
                      bgColor: Theme.of(context).cardColor,
                      textColor: AppColor.BLUE_TEXT,
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  MButtonWidget(
                    width: 80,
                    isEnable: true,
                    colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.3),
                    margin: const EdgeInsets.only(right: 12),
                    onTap: () {
                      if (fileImage != null) {
                        dialogExits();
                      } else {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    },
                    title: '',
                    child: Image.asset(
                      'assets/images/ic-home-blue.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                  Expanded(
                    child: ButtonIconWidget(
                      height: 40,
                      icon: Icons.add_rounded,
                      textSize: 12,
                      title: 'QR giao dịch mới',
                      function: onCreate,
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                    ),
                  ),
                ],
              ),
            ),
            if (fileImage != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * progressBar,
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColor.BLUE_TEXT, width: 4),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            fileImage,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Đang lưu tệp đính kèm.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  void dialogExits() async {
    await showDialog(
      barrierDismissible: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return const DialogExitsView();
      },
    );
  }

  onClick(
    int index,
    QRGeneratedDTO qrGeneratedDTO,
  ) {
    switch (index) {
      case 0:
        onPrint(qrGeneratedDTO);
        return;
      case 1:
        saveImage(context);
        return;
      case 2:
        onCopy(dto: qrGeneratedDTO);
        return;
      case 3:
        share(dto: qrGeneratedDTO);
        return;
    }
  }

  onPrint(QRGeneratedDTO qrGeneratedDTO) async {
    String userId = UserHelper.instance.getUserId();
    BluetoothPrinterDTO bluetoothPrinterDTO =
        await LocalDatabase.instance.getBluetoothPrinter(userId);
    if (bluetoothPrinterDTO.id.isNotEmpty) {
      bool isPrinting = false;
      if (!isPrinting) {
        isPrinting = true;
        DialogWidget.instance
            .showFullModalBottomContent(widget: const PrintingView());
        await PrinterUtils.instance.print(qrGeneratedDTO).then((value) {
          Navigator.pop(context);
          isPrinting = false;
        });
      }
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không thể in',
          msg: 'Vui lòng kết nối với máy in để thực hiện việc in.');
    }
  }

  Future<void> saveImage(BuildContext context) async {
    _waterMarkProvider.updateWaterMark(true);
    DialogWidget.instance.openLoadingDialog();
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.saveImageToGallery(globalKey).then((value) {
        _waterMarkProvider.updateWaterMark(false);
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Đã lưu ảnh',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).cardColor,
          textColor: Theme.of(context).hintColor,
          fontSize: 15,
        );
      });
    });
  }

  Future<void> share({required QRGeneratedDTO dto}) async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance.shareImage(
        key: globalKey,
        textSharing:
            '${dto.bankAccount} - ${dto.bankName}\nĐược tạo bởi vietqr.vn - Hotline 1900.6234'
                .trim(),
      );
    });
  }

  void onCopy({required QRGeneratedDTO dto}) async {
    await FlutterClipboard.copy(ShareUtils.instance.getTextSharing(dto)).then(
      (value) => Fluttertoast.showToast(
        msg: 'Đã sao chép',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).cardColor,
        textColor: Colors.black,
        fontSize: 15,
        webBgColor: 'rgba(255, 255, 255)',
        webPosition: 'center',
      ),
    );
  }
}
