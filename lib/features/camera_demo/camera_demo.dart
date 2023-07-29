import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/contact/save_contact_screen.dart';
import 'package:vierqr/features/scan_qr/blocs/scan_qr_bloc.dart';
import 'package:vierqr/features/scan_qr/blocs/scan_qr_provider.dart';
import 'package:vierqr/features/scan_qr/events/scan_qr_event.dart';
import 'package:vierqr/features/scan_qr/states/scan_qr_state.dart';
import 'package:vierqr/layouts/button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_name_search_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanQrBloc(),
      child: ChangeNotifierProvider(
        create: (context) => ScanQrProvider(),
        child: const CameraScreen(),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late ScanQrBloc _bloc;

  final int _intervalInSeconds = 5;

  final MethodChannel platformChannel = const MethodChannel('scan_qr_code');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = BlocProvider.of(context);
    onNewCameraSelected(cameras[0]);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    CameraController? controller =
        Provider.of<ScanQrProvider>(context, listen: false).controller;
    if (controller != null) {
      return controller.setDescription(cameraDescription);
    } else {
      return Provider.of<ScanQrProvider>(context, listen: false)
          .initializeCameraController(cameraDescription);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController =
        Provider.of<ScanQrProvider>(context, listen: false).controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    }

    // Kiểm tra trạng thái của ứng dụng khi thay đổi (ví dụ: chuyển sang nền hoặc ra khỏi nền)
    if (state == AppLifecycleState.resumed) {
      Provider.of<ScanQrProvider>(context, listen: false)
          .updateResetCamera(true);
    }
  }

  void _takePicture() async {
    CameraController? controller =
        Provider.of<ScanQrProvider>(context, listen: false).controller;
    try {
      if (controller != null) {
        final picture = await controller.takePicture();
        File file = File(picture.path);
        if (!mounted) return;
        Provider.of<ScanQrProvider>(context, listen: false).updateFile(file);
        if (await _scanQr(file)) {
          _timer!.cancel();
        }
      }
    } catch (e) {
      LOG.error('Error taking picture: $e');
    }
  }

  Timer? _timer;

  void _startPhotoTimer() {
    if (_timer != null) {
      return;
    }
    _timer = Timer.periodic(Duration(seconds: _intervalInSeconds), (timer) {
      _takePicture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'Quét QR',
        actions: [
          GestureDetector(
            onTap: () async {
              setState(() {
                // _currentFlashMode = FlashMode.off;
              });
              // await controller!.setFlashMode(FlashMode.off);
            },
            child: const Icon(Icons.flash_on),
          )
        ],
      ),
      body: BlocConsumer<ScanQrBloc, ScanQrState>(
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
            );

            if (!mounted) return;
            Navigator.of(context).pop({
              'type': state.typeContact,
              'data': dto,
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SaveContactScreen(
                    code: state.codeQR ?? '',
                    typeQR: TypeContact.VietQR_ID,
                  ),
                  // settings: RouteSettings(name: ContactEditView.routeName),
                ),
              );
            } else if (state.typeQR == TypeQR.QR_LINK) {
              Navigator.of(context).pop({
                'type': state.typeContact,
                'typeQR': TypeQR.QR_LINK,
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
            }
          }
        },
        builder: (context, state) {
          return Consumer<ScanQrProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/ic-viet-qr.png',
                    width: 140,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width - 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: !(provider.controller == null ||
                              !provider.controller!.value.isInitialized)
                          ? CameraPreview(provider.controller!)
                          : Container(color: AppColor.BLACK),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Hướng khung camera vào mã QR để quét'),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: MButtonWidget(
                          title: '',
                          isEnable: true,
                          colorEnableBgr: AppColor.WHITE,
                          margin: const EdgeInsets.only(left: 20, bottom: 20),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/ic-my-qr-setting.png'),
                                const Text(
                                  'My QR',
                                  style: TextStyle(color: AppColor.GREY_TEXT),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: MButtonWidget(
                          title: '',
                          margin: const EdgeInsets.only(right: 20, bottom: 20),
                          isEnable: true,
                          colorEnableBgr: AppColor.WHITE,
                          onTap: () {
                            _pickAndProcessQRImage();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                    'assets/images/ic-edit-avatar-setting.png'),
                                const Text(
                                  'Tải ảnh QR',
                                  style: TextStyle(color: AppColor.GREY_TEXT),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _pickAndProcessQRImage() async {
    if (_timer != null) {
      _timer!.cancel();
    }
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (!mounted) return;
      Provider.of<ScanQrProvider>(context, listen: false).updateFile(imageFile);

      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      try {
        final data = await platformChannel
            .invokeMethod('processQRImage', {'imageData': base64Image});
        if (data is String && data != '-1') {
          _bloc.add(ScanQrEventGetBankType(code: data));
        } else {
          await DialogWidget.instance.openMsgDialog(
            title: 'Không thể xác nhận mã QR',
            msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
            function: () {
              Navigator.pop(context);
            },
          );
          if (!mounted) return;
          Provider.of<ScanQrProvider>(context, listen: false)
              .updateResetCamera(true);
        }
      } on PlatformException catch (e) {
        LOG.error('Error sending QR image to native: ${e.message}');
      }
    }
  }

  Future<bool> _scanQr(File file) async {
    Uint8List imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    try {
      final data = await platformChannel
          .invokeMethod('processQRImage', {'imageData': base64Image});
      if (data is String && data != '-1') {
        return true;
      }
    } on PlatformException catch (e) {
      LOG.error('Error sending QR image to native: ${e.message}');
    }
    return false;
  }
}
