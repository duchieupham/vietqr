import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vierqr/commons/constants/vietqr/image_constant.dart';
import 'package:vierqr/layouts/image/x_image.dart';

class CacheImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final BoxShape boxShape;
  const CacheImage(
      {super.key,
      required this.imageUrl,
      this.boxShape = BoxShape.rectangle,
      this.radius = 10.0});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const XImage(imagePath: ImageConstant.icAvatar);
      // return Container(
      //   // color: Colors.grey[200],
      //   decoration: BoxDecoration(
      //     color: Colors.grey[200],
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   child: const Center(
      //       child: FittedBox(
      //     fit: BoxFit.fitWidth,
      //     child: Text(
      //       "VietQR",
      //       style: TextStyle(
      //         color: Colors.grey,
      //       ),
      //       textAlign: TextAlign.center,
      //     ),
      //   )),
      // );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 100,
          decoration: BoxDecoration(
            shape: boxShape,
            color: Colors.grey,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        // color: Colors.grey[200],
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(radius),
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
      ),
    );
  }
}
