import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/scan_qr/blocs/scan_qr_bloc.dart';
import 'package:vierqr/features/scan_qr/events/scan_qr_event.dart';
import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({super.key});

  @override
  State<StatefulWidget> createState() => _QRScanView();
}

class _QRScanView extends State<QRScanView>
    with SingleTickerProviderStateMixin {
  static late ScanQrBloc scanQrBloc;
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool isDetected = false;

  @override
  void initState() {
    super.initState();
    scanQrBloc = BlocProvider.of(context);
    // startCameraIOS();
  }

  @override
  void dispose() {
    isDetected = false;
    cameraController.dispose();
    super.dispose();
  }

  //get stk, bankName
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: DefaultTheme.BLACK,
      body: BlocListener<ScanQrBloc, ScanQrState>(
        listener: (context, state) {
          if (state is ScanQrLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is ScanQrNotFoundInformation) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
              title: 'Không thể xác nhận mã QR',
              msg:
                  'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
              function: () {
                Navigator.pop(context);
                isDetected = false;
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }
          if (state is QRScanGetNationalInformationSuccessState) {
            Navigator.pop(context);
            isDetected = false;
            Navigator.pushReplacementNamed(
              context,
              Routes.NATIONAL_INFORMATION,
              arguments: {'dto': state.dto},
            );
          }
          if (state is ScanQrGetBankTypeFailedState) {
            Navigator.pop(context);
            isDetected = false;
            DialogWidget.instance.openMsgDialog(
              title: 'Không tìm thấy thông tin',
              msg:
                  'Không tìm thấy thông tin ngân hàng tương ứng. Vui lòng thử lại sau.',
              function: () {
                Navigator.pop(context);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }
          if (state is ScanQrGetBankTypeSuccessState) {
            Navigator.pop(context);
            if (state.dto.bankCode == 'MB') {
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateSelect(2);
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateRegisterAuthentication(true);
            } else {
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateSelect(1);
              Provider.of<AddBankProvider>(context, listen: false)
                  .updateRegisterAuthentication(false);
            }
            Provider.of<AddBankProvider>(context, listen: false)
                .updateSelectBankType(state.dto);
            isDetected = false;
            Navigator.pushReplacementNamed(
              context,
              Routes.ADD_BANK_CARD,
              arguments: {
                'pageIndex': 2,
                'bankAccount': state.bankAccount,
              },
            );
          }
        },
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 50)),
            SizedBox(
              width: width,
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: DefaultTheme.WHITE,
                      size: 30,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 20)),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Image.asset(
              'assets/images/ic-viet-qr.png',
              width: 100,
              height: 50,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            SizedBox(
              width: width * 0.8,
              height: width * 0.8,
              child: Stack(
                children: [
                  SizedBox(
                    width: width * 0.8,
                    height: width * 0.8,
                    child: Consumer<SuggestionWidgetProvider>(
                      builder: (context, provider, child) {
                        LOG.info(
                            'showCameraPermission: ${provider.showCameraPermission}');
                        return (provider.showCameraPermission)
                            ? const SizedBox()
                            : MobileScanner(
                                controller: cameraController,
                                onDetect: (data) {
                                  if (!isDetected) {
                                    if (data.barcodes.isNotEmpty) {
                                      final String code =
                                          data.barcodes.first.rawValue ?? '';
                                      if (code.isNotEmpty) {
                                        isDetected = true;
                                        scanQrBloc.add(
                                            ScanQrEventGetBankType(code: code));
                                      }
                                    }
                                  }
                                },
                              );
                      },
                    ),
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      'assets/images/ic-scan-qr-frame.png',
                      width: width * 0.8,
                      height: width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Đặt mã QR vào khung để thực hiện việc quét mã',
              style: TextStyle(color: DefaultTheme.WHITE),
            ),
            // const Padding(padding: EdgeInsets.only(top: 20)),
            // ButtonIconWidget(
            //   width: 120,
            //   height: 40,
            //   icon: Icons.image_rounded,
            //   title: 'Tải ảnh QR',
            //   function: () {},
            //   bgColor: DefaultTheme.GREY_VIEW.withOpacity(0.6),
            //   textColor: DefaultTheme.WHITE,
            // ),
            const Spacer(),
            SizedBox(
              width: width,
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 60)),
                  SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await cameraController.toggleTorch();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: DefaultTheme.GREY_VIEW.withOpacity(0.6),
                            ),
                            child: ValueListenableBuilder(
                              valueListenable: cameraController.torchState,
                              builder: (context, state, child) {
                                switch (state as TorchState) {
                                  case TorchState.off:
                                    return const Icon(
                                      Icons.flash_on_rounded,
                                      color: DefaultTheme.WHITE,
                                    );
                                  case TorchState.on:
                                    return const Icon(
                                      Icons.flash_off_rounded,
                                      color: DefaultTheme.WHITE,
                                    );
                                }
                              },
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        const Text('Đèn Flash')
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 80,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await cameraController.switchCamera();
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: DefaultTheme.GREY_VIEW.withOpacity(0.6),
                            ),
                            child: const Icon(
                              Icons.autorenew_rounded,
                              color: DefaultTheme.WHITE,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        const Text('Camera')
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 60)),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
          ],
        ),
      ),
    );
  }
}
