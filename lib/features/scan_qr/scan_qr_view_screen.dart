import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/scan_qr/blocs/scan_qr_bloc.dart';
import 'package:vierqr/features/scan_qr/events/scan_qr_event.dart';
import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
import 'package:vierqr/features/scan_qr/widgets/general_dialog.dart';
import 'package:vierqr/features/scan_qr/widgets/scan_overlay_widget.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class ScanQrViewScreenWidget extends StatefulWidget {
  final TypeScan typeScan;
  const ScanQrViewScreenWidget({super.key, required this.typeScan});

  @override
  State<ScanQrViewScreenWidget> createState() => _ScanQrViewScreenWidgetState();
}

class _ScanQrViewScreenWidgetState extends State<ScanQrViewScreenWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  // late AnimationController _controllerAnimation;
  late ScanQrBloc _bloc;
  bool isScanAll = true;
  final MobileScannerController controller = MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.noDuplicates,
    useNewCameraSelector: true,
  );

  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    // _controllerAnimation = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // )..repeat(reverse: false);
    WidgetsBinding.instance.addObserver(this);
    if (widget.typeScan == TypeScan.ADD_BANK_SCAN_QR) {
      setState(() {
        isScanAll = false;
      });
    }
    _bloc = getIt.get<ScanQrBloc>(param1: isScanAll);
    // unawaited(controller.start());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onScanQr();
    });
  }

  Future<void> _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      setState(() {
        // ignore: sdk_version_since
        // _barcode = barcodes.barcodes.firstOrNull;
      });
      if (barcodes.barcodes.isNotEmpty) {
        final barcode = barcodes.barcodes.first;
        final String? data = barcode.rawValue;
        if (data != null) {
          if (data.isNotEmpty) {
            if (data == TypeQR.NEGATIVE_ONE.value) {
              if (!mounted) return;
              Navigator.pop(context);
            } else if (data == TypeQR.NEGATIVE_TWO.value) {
              DialogWidget.instance.openMsgDialog(
                title: 'Không thể xác nhận mã QR',
                msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
                function: () {
                  Navigator.pop(context);
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              );
            } else {
              if (widget.typeScan == TypeScan.DASHBOARD_SCAN ||
                  widget.typeScan == TypeScan.ADD_BANK_SCAN_QR) {
                _bloc.add(ScanQrEventGetBankType(code: data));
              } else if (widget.typeScan == TypeScan.ADD_BANK) {
                Navigator.of(context).pop({
                  'isScaned': true,
                  'code': data,
                });
              } else if (widget.typeScan == TypeScan.CREATE_QR) {
                Navigator.of(context).pop({
                  'isScaned': true,
                  'code': data,
                });
              } else if (widget.typeScan == TypeScan.USER_EDIT_VIEW) {
                Navigator.of(context).pop({
                  'isScaned': true,
                  'code': data,
                });
              }
            }
          }
        }
      }
    }
  }

  Future<void> onScanQr() async {
    if (await _checkLocationPermission()) {
      _subscription = controller.barcodes.listen(_handleBarcode);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _checkLocationPermission() async {
    int startRequestTime = DateTime.now().millisecondsSinceEpoch;
    var locationPermission = await Permission.camera.request();
    int endRequestTime = DateTime.now().millisecondsSinceEpoch;
    if (locationPermission.isGranted) {
      return true;
    }

    if (locationPermission.isDenied) {
      return false;
    }
    if (locationPermission.isPermanentlyDenied &&
        endRequestTime - startRequestTime < 300) {
      await NavigatorUtils.showGeneralDialog(
        context: context,
        child: const GeneralDialog(),
      );
    }
    return locationPermission.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // final double height = 800;
    final double width = MediaQuery.of(context).size.width;
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset(0, -(height * 0.25))),
      width: width - 60,
      height: height * 0.4,
    );

    return BlocConsumer<ScanQrBloc, ScanQrState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.request == ScanType.SCAN_ERROR) {
          Navigator.of(context).pop({'type': TypeContact.ERROR});
        }

        if (state.request == ScanType.SCAN_NOT_FOUND) {
          Navigator.of(context).pop({'type': TypeContact.NOT_FOUND});
        }

        if (state.request == ScanType.SEARCH_NAME) {
          QRGeneratedDTO dto = QRGeneratedDTO(
            bankCode: state.bankTypeDTO?.bankCode ?? '',
            bankName: state.bankTypeDTO?.bankName ?? '',
            bankAccount: state.bankAccount ?? '',
            userBankName: state.informationDTO?.accountName ?? '',
            amount: '',
            content: '',
            qrCode: state.codeQR ?? '',
            imgId: state.bankTypeDTO?.imageId ?? '',
            bankTypeId: state.bankTypeDTO?.id ?? '',
            isNaviAddBank: state.informationDTO?.isNaviAddBank ?? false,
          );

          if (!mounted) return;
          Navigator.of(context).pop({
            'type': state.typeContact,
            'bankTypeDTO': state.bankTypeDTO,
            'data': dto,
          });
        }

        if (state.request == ScanType.NICK_NAME) {
          Navigator.of(context).pop({
            'type': state.typeContact,
            'typeQR': TypeQR.QR_ID,
            'data': state.vietQRDTO,
          });
        }

        if (state.request == ScanType.SCAN) {
          if (state.typeQR == TypeQR.QR_BANK) {
            String transferType = '';
            if (state.bankTypeDTO?.bankCode == 'MB') {
              transferType = 'INHOUSE';
            } else {
              transferType = 'NAPAS';
            }
            BankNameSearchDTO bankNameSearchDTO = BankNameSearchDTO(
              accountNumber: state.bankAccount ?? '',
              accountType: 'ACCOUNT',
              transferType: transferType,
              bankCode: state.bankTypeDTO?.caiValue ?? '',
            );

            _bloc.add(ScanQrEventSearchName(dto: bankNameSearchDTO));
          } else if (state.typeQR == TypeQR.QR_BARCODE) {
            DialogWidget.instance.openMsgDialog(
              title: 'Không thể xác nhận mã QR',
              msg:
                  'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
              function: () {
                Navigator.pop(context);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          } else if (state.typeQR == TypeQR.QR_ID) {
            _bloc.add(ScanQrEventGetNickName(code: state.codeQR ?? ''));
          } else if (state.typeQR == TypeQR.QR_LINK) {
            Navigator.of(context).pop({
              'type': state.typeContact,
              'typeQR': TypeQR.QR_LINK,
              'data': state.codeQR,
            });
          } else if (state.typeQR == TypeQR.CERTIFICATE) {
            Navigator.of(context).pop({
              'type': state.typeContact,
              'typeQR': TypeQR.CERTIFICATE,
              'data': state.codeQR,
            });
          } else if (state.typeQR == TypeQR.QR_CMT) {
            if (!mounted) return;
            Navigator.pushReplacementNamed(
              context,
              Routes.NATIONAL_INFORMATION,
              arguments: {'dto': state.nationalScannerDTO},
            );
          } else if (state.typeQR == TypeQR.OTHER) {
            Navigator.of(context).pop({
              'type': state.typeContact,
              'typeQR': TypeQR.OTHER,
              'data': state.codeQR,
            });
          } else if (state.typeQR == TypeQR.QR_VCARD) {
            Navigator.of(context).pop({
              'type': state.typeContact,
              'typeQR': TypeQR.QR_VCARD,
              'data': getVCard(state.codeQR ?? ''),
            });
          } else if (state.typeQR == TypeQR.LOGIN_WEB) {
            Navigator.of(context).pop({
              'type': state.typeContact,
              'typeQR': TypeQR.LOGIN_WEB,
              'data': state.codeQR ?? '',
            });
          } else if (state.typeQR == TypeQR.QR_SALE) {
            Navigator.of(context).pop({
              'type': state.typeContact,
              'typeQR': TypeQR.QR_SALE,
              'data': state.codeQR ?? '',
            });
          } else if (state.typeQR == TypeQR.TOKEN_PLUGIN) {
            Navigator.of(context).pop({
              'type': state.typeContact,
              'typeQR': TypeQR.TOKEN_PLUGIN,
              'data': state.codeQR ?? '',
            });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.only(left: 20),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColor.BLACK,
                size: 18,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  controller.toggleTorch();
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 22, bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColor.BLUE_BGR,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, state, child) {
                        switch ((state as MobileScannerState).torchState) {
                          case TorchState.auto:
                            return const Icon(
                              Icons.flash_auto_rounded,
                              color: Colors.black,
                              size: 15,
                            );
                          case TorchState.on:
                            return const Icon(
                              Icons.flashlight_off_outlined,
                              color: Colors.black,
                              size: 15,
                            );
                          case TorchState.off:
                            return const Icon(
                              Icons.flashlight_on_outlined,
                              color: Colors.black,
                              size: 15,
                            );
                          case TorchState.unavailable:
                            return const Icon(
                              Icons.no_flash,
                              color: Colors.grey,
                            );
                        }
                      },
                    )),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                // height: 200,
                color: AppColor.WHITE,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Center(
                    child: XImage(
                      imagePath: 'assets/images/ic-viet-qr.png',
                      height: 35,
                      width: 95,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          // extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            // alignment: Alignment.center,
            children: [
              MobileScanner(
                controller: controller,
                scanWindow: scanWindow,
              ),
              Positioned(
                top: height * 0.1,
                right: 50,
                left: 50,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.black.withOpacity(0.2),
                  ),
                  child: const Center(
                    child: Text(
                      'Di chuyển camera vào mã QR',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: height * 0.05,
              //   right: 30,
              //   left: 30,
              //   child: _buildScanningEffectAnimation(width, height),
              // ),
              CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     alignment: Alignment.bottomCenter,
              //     height: 100,
              //     color: Colors.black.withOpacity(0.4),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         // ToggleFlashlightButton(controller: controller),
              //         // StartStopMobileScannerButton(controller: controller),
              //         Expanded(child: Center(child: _buildBarcode(_barcode))),
              //         // SwitchCameraButton(controller: controller),
              //         // AnalyzeImageFromGalleryButton(controller: controller),
              //       ],
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: 120,
                child: BlocBuilder<BankBloc, BankState>(
                  bloc: getIt.get<BankBloc>(),
                  builder: (context, state) {
                    if (state.listBankTypeDTO.isNotEmpty) {
                      var list = state.listBankTypeDTO;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 30, bottom: 5),
                            child: const Text(
                              'Chúng tôi hỗ trợ mã QR:',
                              style: TextStyle(
                                  color: AppColor.WHITE,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            width: width,
                            child: CarouselSlider(
                              items: list.map(
                                (e) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 3),
                                    child: GradientBorderButton(
                                      borderRadius: BorderRadius.circular(5),
                                      borderWidth: 1,
                                      gradient: VietQRTheme
                                          .gradientColor.brightBlueLinear,
                                      widget: Image(
                                        image: ImageUtils.instance
                                            .getImageNetWork(e.imageId),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                  height: 45,
                                  autoPlay: true,
                                  viewportFraction: 0.3,
                                  pageSnapping: false,
                                  autoPlayCurve: Curves.linear,
                                  autoPlayInterval: const Duration(seconds: 2),
                                  autoPlayAnimationDuration:
                                      const Duration(seconds: 2)),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.BLUE_BGR,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: const Icon(
                                Icons.flip_camera_android_outlined,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                            const Text(
                              'Đổi camera',
                              style: TextStyle(
                                  color: AppColor.BLACK, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.BLUE_BGR,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: const Icon(
                                Icons.photo_library_outlined,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Tải ảnh lên',
                              style: TextStyle(
                                  color: AppColor.BLACK, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      // ToggleFlashlightButton(controller: controller),
                      // SwitchCameraButton(controller: controller),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildScanningEffectAnimation(width, height) {
  //   return SizedBox(
  //     width: width,
  //     height: height * 0.4,
  //     child: AnimatedBuilder(
  //       animation: _controllerAnimation,
  //       builder: (context, child) {
  //         const scanningGradientHeight = 80.0;
  //         final scorePosition =
  //             _controllerAnimation.value * (400 - scanningGradientHeight);

  //         final opacity = (1.0 - (scorePosition / 400).abs()).clamp(0.0, 1.0);
  //         return Stack(
  //           children: [
  //             Positioned(
  //               top: scorePosition,
  //               left: 0,
  //               right: 0,
  //               child: Opacity(
  //                 opacity: opacity,
  //                 child: Container(
  //                   height: scanningGradientHeight,
  //                   decoration: BoxDecoration(
  //                     gradient: LinearGradient(
  //                       begin: Alignment.topCenter,
  //                       end: Alignment.bottomCenter,
  //                       stops: const [
  //                         0.0,
  //                         0.2,
  //                         0.9,
  //                         0.95,
  //                         1,
  //                       ],
  //                       colors: [
  //                         Colors.white.withOpacity(0.1 * opacity),
  //                         Colors.white.withOpacity(0.2 * opacity),
  //                         Colors.white.withOpacity(0.5 * opacity),
  //                         Colors.white.withOpacity(opacity),
  //                         Colors.white.withOpacity(opacity),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }

  VCardModel getVCard(String data) {
    if (data.isEmpty) {
      return VCardModel();
    }

    List<String> list = data.split("\r\n");

    String name = '';
    String phone = '';
    String email = '';
    String company = '';
    String address = '';
    String website = '';

    for (var element in list) {
      if (element.contains('FN;CHARSET=UTF-8')) {
        List<String> splits = element.split(':');
        name = splits.last;
      }

      if (element.contains('TEL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          phone = splits.last;
        }
      }
      if (element.contains('EMAIL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          email = splits.last;
        }
      }
      if (element.contains('ORG')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          company = splits.last;
        }
      }
      if (element.contains('LABEL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          address = splits.last;
        }
      }
      if (element.contains('URL')) {
        List<String> splits = element.split(':');
        if (splits.last.isNotEmpty) {
          website = splits.last;
        }
      }
    }

    VCardModel model = VCardModel(
      fullname: name,
      phoneNo: phone,
      email: email,
      companyName: company,
      website: website,
      address: address,
      userId: '',
      additionalData: '',
      code: data,
    );

    return model;
  }
}

enum TypeScan {
  ADD_BANK,
  ADD_BANK_SCAN_QR,
  CREATE_QR,
  USER_EDIT_VIEW,
  USER_INFO_VIEW,
  DASHBOARD_SCAN,
}
