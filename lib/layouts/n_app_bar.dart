import 'package:flutter/material.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class NAppBarWidget extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? callBackHome;

  const NAppBarWidget({
    super.key,
    this.onPressed,
    this.callBackHome,
  });

  @override
  State<NAppBarWidget> createState() => _NAppBarWidgetState();
}

class _NAppBarWidgetState extends State<NAppBarWidget> {
  bool isVNSelected = true;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 120,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: widget.onPressed,
        child: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 18,
              ),
              XImage(
                imagePath: 'assets/images/ic-viet-qr.png',
                height: 30,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            VietQRButton.solid(
              borderRadius: 50,
              onPressed: () {},
              isDisabled: false,
              width: 40,
              size: VietQRButtonSize.medium,
              child: const XImage(
                imagePath: 'assets/images/ic-headphone-black.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 8),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE1EFFF),
                      Color(0xFFE5F9FF),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isVNSelected = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: isVNSelected
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          color: isVNSelected ? null : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: isVNSelected
                            ? const Text(
                                'VN',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: const Text(
                                  'VN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isVNSelected = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: !isVNSelected
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          color: !isVNSelected ? null : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: !isVNSelected
                            ? const Text(
                                'EN',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: const Text(
                                  'EN',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
