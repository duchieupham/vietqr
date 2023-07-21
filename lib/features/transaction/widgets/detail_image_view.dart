import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';

class DetailImageView extends StatelessWidget {
  final String image;

  const DetailImageView({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLACK,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: ImageUtils.instance.getImageNetworkCache(image),
            ),
            Row(
              children: [
                const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.clear,
                    color: AppColor.TRANSPARENT,
                  ),
                ),
                const Expanded(
                  child: Text(
                    '1/1',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColor.WHITE, fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: AppColor.WHITE,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
