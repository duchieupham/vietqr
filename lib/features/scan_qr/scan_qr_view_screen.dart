import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class ScanQrViewScreenWidget extends StatefulWidget {
  const ScanQrViewScreenWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQrViewScreenWidgetState();
}

class _ScanQrViewScreenWidgetState extends State<ScanQrViewScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final scanWindow = Rect.fromCenter(
      center: Offset(
        0,
        -(height * 0.15),
      ),
      width: 300,
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
          Container(
              margin: const EdgeInsets.only(right: 22),
              decoration: BoxDecoration(
                color: AppColor.BLUE_BGR,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.flashlight_on,
                color: Colors.black,
                size: 13,
              ))
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
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: controller,
            scanWindow: scanWindow,
            // overlayBuilder: (context, constraints) {
            //   // return Padding(
            //   //   padding: const EdgeInsets.all(16.0),
            //   //   child: Align(
            //   //     alignment: Alignment.bottomCenter,
            //   //     child: ScannedBarcodeLabel(barcodes: controller.barcodes),
            //   //   ),
            //   // );
            // },
          ),
          Positioned(
            top: height * 0.15,
            child: Container(
              height: 40,
              width: 220,
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
            top: height * 0.12,
            child: _buildScanningEffectAnimation(),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              // if (!value.isInitialized ||
              //     !value.isRunning ||
              //     value.error != null) {
              //   return const SizedBox();
              // }

              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          Positioned(
            bottom: 50,
            child: Container(
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
                          style: TextStyle(color: Colors.white, fontSize: 13),
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
                          style: TextStyle(color: Colors.white, fontSize: 13),
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
  }

  Widget _buildScanningEffectAnimation() {
    return SizedBox(
      width: 300,
      height: 350,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          const scanningGradientHeight = 80.0;
          final scorePosition =
              _controller.value * (400 - scanningGradientHeight);

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
    super.dispose();
    _controller.dispose();
    await controller.dispose();
  }
}

class ScannerAnimation extends AnimatedWidget {
  const ScannerAnimation({
    super.key,
    required Animation<double> animation,
    this.scanningColor = Colors.blue,
    this.scanningHeightOffset = 0.4,
  }) : super(
          listenable: animation,
        );

  final Color? scanningColor;
  final double scanningHeightOffset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final scanningGradientHeight =
            constrains.maxHeight * scanningHeightOffset;
        final animation = listenable as Animation<double>;
        final value = animation.value;
        final scorePosition =
            (value * constrains.maxHeight * 2) - (constrains.maxHeight);

        final color = scanningColor ?? Colors.blue;

        return Stack(
          children: [
            Container(
              height: scanningGradientHeight,
              transform: Matrix4.translationValues(0, scorePosition, 0),
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
                    color.withOpacity(0.05),
                    color.withOpacity(0.1),
                    color.withOpacity(0.4),
                    color,
                    color,
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
