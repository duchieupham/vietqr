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
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

import '../../models/qr_generated_dto.dart';
import '../../services/providers/show_qr_provider.dart';
import '../../services/providers/water_mark_provider.dart';

class ShowQr extends StatefulWidget {
  final QRGeneratedDTO dto;
  const ShowQr({Key? key, required this.dto}) : super(key: key);

  @override
  State<ShowQr> createState() => _ShowQrState();
}

class _ShowQrState extends State<ShowQr> {
  final GlobalKey globalKey = GlobalKey();
  final _waterMarkProvider = WaterMarkProvider(false);

  onClick(int index) {
    switch (index) {
      case 0:
        onPrint(widget.dto);
        return;
      case 1:
        saveImage(context);
        return;
      case 2:
        onCopy(dto: widget.dto);
        return;
      case 3:
        share(dto: widget.dto);
        return;
    }
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

  onPrint(QRGeneratedDTO qrGeneratedDTO) async {
    BluetoothPrinterDTO bluetoothPrinterDTO =
        await LocalDatabase.instance.getBluetoothPrinter('vietQR');
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
          textColor: Theme.of(context).cardColor,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => ShowQRProvider(),
      child: Consumer<ShowQRProvider>(builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            child: RepaintBoundaryWidget(
              globalKey: globalKey,
              builder: (key) {
                return Container(
                  color: AppColor.GREY_BG,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        child: VietQr(qrGeneratedDTO: widget.dto),
                      ),
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
                      const SizedBox(
                        height: 120,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          bottomSheet: _buildButton(
            context: context,
            fileImage: provider.imageFile,
            progressBar: provider.progressBar,
            onClick: (index) {
              onClick(index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildButton(
      {File? fileImage,
      double progressBar = 0,
      required BuildContext context,
      required Function(int) onClick}) {
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
              child: MButtonWidget(
                isEnable: true,
                colorEnableBgr: AppColor.BLUE_TEXT,
                margin: EdgeInsets.zero,
                onTap: () {
                  Navigator.pop(context);
                },
                title: 'Đóng',
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
}
