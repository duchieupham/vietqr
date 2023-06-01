import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
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
        img.Image compressedImage = img.copyResize(image!);
        result = File('${file.parent.path}/compressed_${file.path}')
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
}
