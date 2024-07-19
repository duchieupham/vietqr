import 'package:flutter/material.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class ServiceVietqrWidget extends StatefulWidget {
  const ServiceVietqrWidget({super.key});

  @override
  State<ServiceVietqrWidget> createState() => _ServiceVietqrWidgetState();
}

class _ServiceVietqrWidgetState extends State<ServiceVietqrWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  XImage(
                    imagePath: 'assets/images/ic-diamond.png',
                    width: 40,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GradientText(
                          'VietQR Plus',
                          style: TextStyle(fontSize: 12),
                          gradient: LinearGradient(colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0072FF),
                          ]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kích hoạt đến 07/09/2026',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                print('gia han dich vu vietqr');
              },
              child: Container(
                height: 128,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF6FF),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientText(
                          'Gia hạn\ndịch vụ\nVietQR',
                          style: TextStyle(fontSize: 12),
                          gradient: LinearGradient(colors: [
                            Color(0xFF00C6FF),
                            Color(0xFF0072FF),
                          ]),
                        ),
                        XImage(
                          imagePath: 'assets/images/ic-infinity.png',
                          width: 40,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Trải nghiệm các tính năng không giới hạn.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                      ),
                    ),
                    // Spacer(),
                    SizedBox(height: 8),
                    XImage(
                      imagePath: 'assets/images/ic-arrow-boder-blue.png',
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
