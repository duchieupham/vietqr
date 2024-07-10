import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import 'x_place_holder.dart';

class XImage extends StatelessWidget {
  const XImage(
      {super.key,
      required this.imagePath,
      this.borderRadius = BorderRadius.zero,
      this.svgIconColor,
      this.fit,
      this.animationController,
      this.width,
      this.height,
      this.color,
      this.errorWidget,
      this.isImgId = false
      // this.onLoaded,
      });

  final String imagePath;
  final BorderRadius? borderRadius;
  final ColorFilter? svgIconColor;
  final BoxFit? fit;
  final AnimationController? animationController;
  final double? width;
  final double? height;

  final Color? color;
  final Widget? errorWidget;
  final bool? isImgId;

  // final Function(LottieComposition)? onLoaded;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (imagePath.endsWith('.svg')) {
      imageWidget = _buildSvgImage(context);
    }
    // else if (imagePath.endsWith('.json')) {
    //   imageWidget = _buildLottieAnimation(context);
    // }
    else if (imagePath.startsWith('assets/images')) {
      imageWidget = _buildAssetImage(context);
    } else if (imagePath.startsWith('file://') ||
        imagePath.startsWith('/data/') ||
        imagePath.startsWith('/Users/') ||
        imagePath.startsWith('/private/var/mobile')) {
      imageWidget = _buildImageFromFile(context);
    } else if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      imageWidget = _buildImageNetwork(context);
    } else {
      imageWidget = _buildEmptyImage(context);
    }

    return borderRadius != null
        ? ClipRRect(
            borderRadius: borderRadius!,
            child: imageWidget,
          )
        : imageWidget;
  }

  Widget _buildImageNetwork(BuildContext context) {
    if (!imagePath.contains('http')) {
      return CachedNetworkImage(
        fit: fit ?? BoxFit.cover,
        imageUrl: '${getIt.get<AppConfig>().getBaseUrl}images/$imagePath',
        width: width,
        height: height,
        httpHeaders: {"Authorization": 'Bearer ${SharePrefUtils.tokenInfo}'},
        placeholder: (_, __) => XPlaceHolder(
          width: width ?? 100,
          height: height ?? 100,
          shimmerBaseColor: Colors.grey.shade300,
          shimmerHighlightColor: Colors.grey.shade100,
        ),
        errorWidget: (context, url, error) =>
            errorWidget ?? const SizedBox.shrink(),
      );
    }

    return CachedNetworkImage(
      fit: fit ?? BoxFit.cover,
      imageUrl: imagePath,
      width: width,
      height: height,
      placeholder: (_, __) => XPlaceHolder(
        width: width ?? 100,
        height: height ?? 100,
        shimmerBaseColor: Colors.grey.shade300,
        shimmerHighlightColor: Colors.grey.shade100,
      ),
      errorWidget: (context, url, error) =>
          errorWidget ?? const SizedBox.shrink(),
    );
  }

  // Widget _buildLottieAnimation(BuildContext context) {
  //   return Lottie.asset(
  //     imagePath,
  //     width: width,
  //     height: height,
  //     fit: fit ?? BoxFit.cover,
  //     controller: animationController,
  //     onLoaded: onLoaded,
  //   );
  // }

  Widget _buildAssetImage(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: fit,
      width: width,
      height: height,
      color: color,
    );
  }

  Widget _buildImageFromFile(BuildContext context) {
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const SizedBox.shrink();
      },
    );
  }

  Widget _buildSvgImage(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      color: AppColor.GREEN,
      colorFilter: svgIconColor,
    );
  }

  Widget _buildEmptyImage(BuildContext context) {
    return Container(
      // color: Colors.grey[200],
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: const Center(
          child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          "VQR",
          style: TextStyle(
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      )),
    );
    // return Image.asset(
    //   ImageConstant.icAvatar,
    //   fit: fit,
    //   width: width,
    //   height: height,
    //   color: color,
    // );
  }
}
