import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/log.dart';

class BottomSheetImage extends StatelessWidget {
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(
              title: 'Chụp ảnh',
              url: 'assets/images/ic-camera.png',
              onTap: () async {
                final data = await _handleTapCamera();
                if (data != null) {
                  Navigator.of(context).pop(data);
                }
              }),
          const Divider(),
          _buildItem(
              title: 'Thư viện',
              url: 'assets/images/ic-edit-avatar-setting.png',
              onTap: () async {
                await Permission.mediaLibrary.request();
                await imagePicker.pickImage(source: ImageSource.gallery).then(
                  (pickedFile) async {
                    if (pickedFile != null) {
                      Navigator.of(context).pop(pickedFile);
                    }
                  },
                );
              }),
        ],
      ),
    );
  }

  Widget _buildItem(
      {required String url, required String title, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(
              url,
              width: 40,
            ),
            Text(
              title,
              style: TextStyle(color: AppColor.BLUE_TEXT),
            ),
          ],
        ),
      ),
    );
  }

  Future _handleTapCamera() async {
    int startRequestTime = DateTime.now().millisecondsSinceEpoch;
    PermissionStatus cameraPermission = await Permission.camera.request();
    int endRequestTime = DateTime.now().millisecondsSinceEpoch;
    int requestDuration = endRequestTime - startRequestTime;
    if (cameraPermission.isDenied) return;
    if ((cameraPermission.isPermanentlyDenied && requestDuration < 300) ||
        cameraPermission.isRestricted) {
      openAppSettings();
    }
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return null;
      return pickedFile;
      // widget.onPhotoTaken(File(pickedFile.path));
    } catch (err) {
      LOG.error("Camera Photo Err: " + err.toString());
    }
  }
}
