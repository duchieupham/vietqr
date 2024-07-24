import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:path/path.dart' as path;

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
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: AppColor.WHITE,
                  ),
                ),
                Expanded(
                  child: Text(
                    path.basename(image),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColor.WHITE, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                // IconButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   icon: const Icon(
                //     Icons.clear,
                //     color: AppColor.TRANSPARENT,
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
