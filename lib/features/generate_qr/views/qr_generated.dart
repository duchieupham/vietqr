import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'dart:ui' as ui;

import 'package:vierqr/services/sqflite/local_database.dart';

class QRGenerated extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRGenerated();

  const QRGenerated({
    Key? key,
  }) : super(key: key);
}

class _QRGenerated extends State<QRGenerated> {
  static final GlobalKey globalKey = GlobalKey();
  static late QRGeneratedDTO qrGeneratedDTO;
  final WaterMarkProvider _waterMarkProvider = WaterMarkProvider(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    qrGeneratedDTO = args['qrGeneratedDTO'];
    return Scaffold(
      body: Stack(
        children: [
          _buildComponent(
            context: context,
            dto: qrGeneratedDTO,
            globalKey: globalKey,
            width: width,
            height: height,
          ),
          Positioned(
            bottom: 70,
            child: SizedBox(
              width: width,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonIconWidget(
                    width: width * 0.2,
                    height: 40,
                    icon: Icons.print_rounded,
                    title: '',
                    function: () async {
                      String userId =
                          UserInformationHelper.instance.getUserId();
                      BluetoothPrinterDTO bluetoothPrinterDTO =
                          await LocalDatabase.instance
                              .getBluetoothPrinter(userId);
                      if (bluetoothPrinterDTO.id.isNotEmpty) {
                        bool isPrinting = false;
                        if (!isPrinting) {
                          isPrinting = true;
                          DialogWidget.instance.showFullModalBottomContent(
                              widget: const PrintingView());
                          await PrinterUtils.instance
                              .print(qrGeneratedDTO)
                              .then((value) {
                            Navigator.pop(context);
                            isPrinting = false;
                          });
                        }
                      } else {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Không thể in',
                            msg:
                                'Vui lòng kết nối với máy in để thực hiện việc in.');
                      }
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.ORANGE,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ButtonIconWidget(
                    width: width * 0.2,
                    height: 40,
                    icon: Icons.photo_rounded,
                    title: '',
                    function: () async {
                      _waterMarkProvider.updateWaterMark(true);
                      DialogWidget.instance.openLoadingDialog();
                      await Future.delayed(const Duration(milliseconds: 200),
                          () async {
                        await ShareUtils.instance
                            .saveImageToGallery(globalKey)
                            .then((value) {
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
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.RED_CALENDAR,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ButtonIconWidget(
                    width: width * 0.2,
                    height: 40,
                    icon: Icons.copy_rounded,
                    title: '',
                    function: () async {
                      await FlutterClipboard.copy(ShareUtils.instance
                              .getTextSharing(qrGeneratedDTO))
                          .then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Theme.of(context).cardColor,
                          textColor: Theme.of(context).cardColor,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.BLUE_TEXT,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ButtonIconWidget(
                    width: width * 0.2,
                    height: 40,
                    icon: Icons.share_rounded,
                    title: '',
                    function: () async {
                      await share(dto: qrGeneratedDTO);
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: DefaultTheme.GREEN,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              width: width,
              alignment: Alignment.center,
              child: ButtonIconWidget(
                width: width * 0.8 + 30,
                height: 40,
                icon: Icons.home_rounded,
                title: 'Trang chủ',
                function: () {
                  Navigator.pop(context);
                },
                bgColor: DefaultTheme.GREEN,
                textColor: DefaultTheme.WHITE,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<int>> printImage(
      PaperSize paper, CapabilityProfile profile) async {
    final Generator generator = Generator(paper, profile);
    List<int> bytes = [];

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  Future<void> share({required QRGeneratedDTO dto}) async {
    _waterMarkProvider.updateWaterMark(true);
    await Future.delayed(const Duration(milliseconds: 200), () async {
      await ShareUtils.instance
          .shareImage(
            key: globalKey,
            textSharing:
                '${dto.bankAccount} - ${dto.bankName}\nĐược tạo bởi vietqr.vn - Hotline 19006234'
                    .trim(),
          )
          .then((value) => _waterMarkProvider.updateWaterMark(false));
    });
  }

  Widget _buildComponent({
    required BuildContext context,
    required GlobalKey globalKey,
    required QRGeneratedDTO dto,
    required double width,
    required double height,
  }) {
    return RepaintBoundaryWidget(
        globalKey: globalKey,
        builder: (key) {
          return Container(
            width: width,
            height: height,
            padding: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: Image.asset('assets/images/bg-qr.png').image),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (height > 700)
                  const Padding(padding: EdgeInsets.only(top: 20)),
                const Padding(padding: EdgeInsets.only(top: 30)),
                VietQRWidget(
                  width: width,
                  qrGeneratedDTO: dto,
                  content: dto.content,
                  isSmallWidget: height <= 800,
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
                              color: DefaultTheme.WHITE,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(text: 'Được tạo bởi '),
                              TextSpan(
                                text: 'vietqr.vn',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(text: ' - '),
                              TextSpan(text: 'Hotline '),
                              TextSpan(
                                text: '19006234',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
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
          );
        });
  }

  void backToHome(BuildContext context) {
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false)
        .updateIndex(0);
    Navigator.pop(context);
  }
}
