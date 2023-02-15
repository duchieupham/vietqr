import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';

class AmbientAvatarWidget extends StatelessWidget {
  final String imgId;
  final double size;
  static const double blurRadius = 25.0;
  static const double blurSigma = 20.0;

  const AmbientAvatarWidget({
    super.key,
    required this.imgId,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Opacity(
                opacity: 0.6,
                child: Container(
                  width: size + blurRadius,
                  height: size + blurRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ImageUtils.instance.getImageNetWork(imgId),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              color: DefaultTheme.TRANSPARENT,
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ImageUtils.instance.getImageNetWork(imgId),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
