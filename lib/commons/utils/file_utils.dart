import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/utils/log.dart';

class FileUtils {
  const FileUtils._privateConsrtructor();

  static const FileUtils _instance = FileUtils._privateConsrtructor();

  static FileUtils get instance => _instance;
  static const int kb = 1024;
  static const int second = 2;

  File? compressImage(File file) {
    File? result;
    try {
      double sizeMB = (file.lengthSync()) / pow(kb, 2);
      int quality = 100;
      if (sizeMB > 1) {
        if (sizeMB > 1 && sizeMB < second) {
          quality = 70;
        } else if (sizeMB >= second && sizeMB < (second * 2)) {
          quality = 50;
        } else if (sizeMB >= (second * 2) && sizeMB < (second * 4)) {
          quality = 20;
        } else {
          quality = 40;
        }
        img.Image? image = img.decodeImage(file.readAsBytesSync());
        img.Image compressedImage = img.copyResize(image!, width: 200);
        result = File(
            '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg')
          ..writeAsBytesSync(img.encodeJpg(compressedImage, quality: quality));
      } else {
        result = file;
      }
    } catch (e) {
      LOG.error(e.toString());
      result = file;
    }
    return result;
  }

  static Future<File> resizeImage(
    File imageFile,
    double outputWidth,
    double outputHeight, {
    String? outputFileName,
  }) async {
    // Delete file if exists
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String resizedImagePath =
        appDocDir.path + "/" + (outputFileName ?? getFileName(imageFile));
    File resizedFile = File(resizedImagePath);
    // Save the thumbnail as a PNG.
    if (resizedFile.existsSync()) {
      resizedFile.deleteSync();
    } else {}
    if (Platform.isAndroid) {
      final platform = MethodChannel('com.vietqr.product');
      final int resizeResult = await platform.invokeMethod("resizeImage", {
        "filePath": imageFile.path,
        "outputPath": resizedImagePath,
        "outputWidth": outputWidth,
        "outputHeight": outputHeight,
      });
      if (resizeResult == 1) {
        return File(resizedImagePath);
      }
    }
    // Read a jpeg image from file.
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(
      image!,
      width: outputWidth.round(),
      height: outputHeight.round(),
    );
    if (resizedImagePath.endsWith("png")) {
      resizedFile.writeAsBytesSync(img.encodePng(resizedImage));
    } else {
      resizedFile.writeAsBytesSync(img.encodeJpg(resizedImage));
    }
    return resizedFile;
  }

  static String getFileName(File file) {
    List<String> fileNameSplit = file.path.split("/");
    return fileNameSplit[fileNameSplit.length - 1];
  }
}
