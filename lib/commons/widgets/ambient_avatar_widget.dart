import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';

class AmbientAvatarWidget extends StatelessWidget {
  final String imgId;
  final File? imageFile;
  final double size;
  final bool onlyImage;
  static const double blurRadius = 25.0;
  static const double blurSigma = 20.0;

  const AmbientAvatarWidget({
    super.key,
    required this.imgId,
    required this.size,
    this.imageFile,
    this.onlyImage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (onlyImage) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: (imageFile != null)
                ? Image.file(imageFile!).image
                : ImageUtils.instance.getImageNetworkCache(imgId),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: (imageFile != null)
                ? Image.file(imageFile!).image
                : ImageUtils.instance.getImageNetworkCache(imgId),
          ),
        ),
      ),
    );
  }
}
