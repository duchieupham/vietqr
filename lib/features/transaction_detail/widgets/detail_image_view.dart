import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:path/path.dart' as path;
import 'package:vierqr/layouts/image/x_image.dart';

class DetailImageView extends StatefulWidget {
  final String image;
  final String imgUrl;
  const DetailImageView({super.key, required this.image, this.imgUrl = ''});

  @override
  State<DetailImageView> createState() => _DetailImageViewState();
}

class _DetailImageViewState extends State<DetailImageView> {
  Future<void> _downloadImage(bool isSave) async {
    String url = '${getIt.get<AppConfig>().getBaseUrl}images/${widget.image}';
    final http.Response response = await http.get(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    // Create an image name
    // var filename = '${dir.path}/image.png';
    String filename =
        await _getUniqueFileName(dir.path, 'your_picture_name.png');
    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);
    // Ask the user to save it
    if (isSave) {
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      // ignore: unused_local_variable
      final finalPath = await FlutterFileDialog.saveFile(params: params);
    } else {
      final result =
          await Share.shareXFiles([XFile(file.path)], text: 'your_image_name');

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the picture!');
      }
    }
  }

  Future<String> _getUniqueFileName(String dir, String filename) async {
    String baseName = path.basenameWithoutExtension(filename);
    String extension = path.extension(filename);
    String uniqueFilename = filename;
    int counter = 1;

    while (await File(path.join(dir, uniqueFilename)).exists()) {
      uniqueFilename = '$baseName($counter)$extension';
      counter++;
    }

    return path.join(dir, uniqueFilename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLACK,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider:
                  ImageUtils.instance.getImageNetworkCache(widget.image),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    const SizedBox(width: 10),
                    const Text(
                      // path.basename(image),
                      'your_image_name.png',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColor.WHITE, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColor.WHITE),
                if (widget.imgUrl.isNotEmpty) ...[
                  const Spacer(),
                  const Divider(color: AppColor.WHITE),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            _downloadImage(true);
                          },
                          child: const SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                XImage(
                                  imagePath: 'assets/images/ic-dowload.png',
                                  color: AppColor.WHITE,
                                  width: 30,
                                  height: 30,
                                ),
                                Text(
                                  'Tải ảnh',
                                  style: TextStyle(
                                      fontSize: 15, color: AppColor.WHITE),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _downloadImage(false);
                          },
                          child: const SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                XImage(
                                  imagePath: 'assets/images/ic-share-black.png',
                                  color: AppColor.WHITE,
                                  width: 30,
                                  height: 30,
                                ),
                                Text(
                                  'Chia sẻ',
                                  style: TextStyle(
                                      fontSize: 15, color: AppColor.WHITE),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
