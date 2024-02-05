import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/printer_utils.dart';
import 'package:vierqr/commons/utils/share_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/commons/widgets/widget_qr.dart';
import 'package:vierqr/features/create_qr/widgets/dialog_exits_view.dart';
import 'package:vierqr/features/printer/views/printing_view.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/water_mark_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:vierqr/services/sqflite/local_database.dart';

class CreateQRSuccess extends StatefulWidget {
  final QRGeneratedDTO dto;
  final GestureTapCallback onCreate;
  final List<BankTypeDTO> listBanks;

  CreateQRSuccess(
      {super.key,
      required this.dto,
      required this.onCreate,
      required this.listBanks});

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
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Nhận tiền từ mọi ngân hàng và ví điện thử có hỗ trợ VietQR',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              RepaintBoundaryWidget(
                globalKey: globalKey,
                builder: (key) {
                  return WidgetQr(
                    qrGeneratedDTO: widget.dto,
                    isVietQR: true,
                    updateQRGeneratedDTO: (data) {},
                    isCreateQr: true,
                  );
                },
              ),
              if (widget.dto.qrLink.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'QR Link:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Đường dẫn thanh toán qua mã VietQR',
                  style: TextStyle(
                      fontSize: 12, color: AppColor.GREY_TEXT, height: 1.4),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.WHITE,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.dto.qrLink,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColor.BLUE_TEXT,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      GestureDetector(
                        onTap: onCopy,
                        child: Image.asset(
                          'assets/images/ic-copy-blue.png',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              ...[
                const SizedBox(height: 24),
                Text(
                  'Thanh toán qua app ngân hàng:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Chọn ngân hàng để thanh toán',
                  style: TextStyle(
                      fontSize: 12, color: AppColor.GREY_TEXT, height: 1.4),
                ),
                const SizedBox(height: 8),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 2,
                    ),
                    itemCount: widget.listBanks.length,
                    itemBuilder: (context, index) {
                      var data = widget.listBanks[index];
                      return GestureDetector(
                        onTap: () async {},
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColor.WHITE,
                                image: data.file != null
                                    ? DecorationImage(
                                        image: FileImage(data.file!))
                                    : DecorationImage(
                                        image: ImageUtils.instance
                                            .getImageNetWork(data.imageId)),
                              ),
                              margin: EdgeInsets.all(4),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
              onGoHome: () {
                if (bt.imageFile != null) {
                  dialogExits();
                } else {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              onCreate: widget.onCreate);
        },
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required Function() onGoHome,
    required Function() onCreate,
  }) {
    return Container(
      decoration: BoxDecoration(color: AppColor.WHITE),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onGoHome,
            child: Container(
              height: 40,
              padding: const EdgeInsets.only(left: 8, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.WHITE,
                border: Border.all(color: AppColor.BLUE_TEXT),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/ic-tb-dashboard-selected.png',
                    color: AppColor.BLUE_TEXT,
                  ),
                  Text(
                    'Trang chủ',
                    style: TextStyle(
                      color: AppColor.BLUE_TEXT,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: MButtonWidget(
              title: '+ Tạo QR giao dịch mới',
              isEnable: true,
              margin: EdgeInsets.zero,
              colorEnableText: AppColor.WHITE,
              onTap: onCreate,
            ),
          ),
        ],
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

  void onCopy() async {
    Clipboard.setData(ClipboardData(text: widget.dto.qrLink));
    Fluttertoast.showToast(
      msg: 'Đã sao chép',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Theme.of(context).cardColor,
      textColor: Theme.of(context).hintColor,
      fontSize: 15,
    );
  }
}
