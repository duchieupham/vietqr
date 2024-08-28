import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_gradient_border_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class ScanQrViewScreenWidget extends StatefulWidget {
  const ScanQrViewScreenWidget({super.key});

  @override
  State<ScanQrViewScreenWidget> createState() => _ScanQrViewScreenWidgetState();
}

class _ScanQrViewScreenWidgetState extends State<ScanQrViewScreenWidget>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late AnimationController _controllerAnimation;
  final MobileScannerController controller = MobileScannerController(
    autoStart: true,
    detectionSpeed: DetectionSpeed.noDuplicates,
    useNewCameraSelector: true,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controllerAnimation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);
    // unawaited(controller.start());
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset(0, -height * 0.15)),
      width: width - 60,
      height: 350,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              controller.toggleTorch();
            },
            child: Container(
                margin: const EdgeInsets.only(right: 22),
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
            // height: 120,
            padding: const EdgeInsets.only(top: 30),
            color: Colors.transparent,
            child: const Center(
              child: XImage(
                imagePath: 'assets/images/ic-viet-qr.png',
                height: 50,
                width: 130,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        // alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            scanWindow: scanWindow,
          ),
          Positioned(
            top: height * 0.15,
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
          Positioned(
            top: Offset(0, height * 0.15).dy,
            right: 30,
            left: 30,
            child: _buildScanningEffectAnimation(width),
          ),
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
            bottom: 50,
            child: Column(
              children: [
                BlocBuilder<BankBloc, BankState>(
                  bloc: getIt.get<BankBloc>(),
                  builder: (context, state) {
                    if (state.listBankTypeDTO.isNotEmpty) {
                      var list = state.listBankTypeDTO;
                      return SizedBox(
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
                                  gradient: VietQRTheme.gradientColor.brightBlueLinear,
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
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.BLUE_BGR,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(15),
                              child: const Icon(
                                Icons.qr_code_rounded,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'QR của tôi',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Tải ảnh lên',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      // ToggleFlashlightButton(controller: controller),
                      // SwitchCameraButton(controller: controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningEffectAnimation(width) {
    return SizedBox(
      width: width,
      height: 350,
      child: AnimatedBuilder(
        animation: _controllerAnimation,
        builder: (context, child) {
          const scanningGradientHeight = 80.0;
          final scorePosition =
              _controllerAnimation.value * (400 - scanningGradientHeight);

          final opacity = (1.0 - (scorePosition / 400).abs()).clamp(0.0, 1.0);
          return Stack(
            children: [
              Positioned(
                top: scorePosition,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    height: scanningGradientHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [
                          0.0,
                          0.2,
                          0.9,
                          0.95,
                          1,
                        ],
                        colors: [
                          Colors.green.withOpacity(0.1 * opacity),
                          Colors.green.withOpacity(0.2 * opacity),
                          Colors.green.withOpacity(0.5 * opacity),
                          Colors.green.withOpacity(opacity),
                          Colors.green.withOpacity(opacity),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
