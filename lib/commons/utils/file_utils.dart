import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:vierqr/commons/utils/log.dart';

class FileUtils {
  const FileUtils._privateConsrtructor();

  static const FileUtils _instance = FileUtils._privateConsrtructor();
  static FileUtils get instance => _instance;

  File? compressImage(File file) {
    File? result;
    try {
      int size = file.lengthSync();
      print('----sized:$size');
      int quality = 100;
      if (size > 1048576) {
        if (size > 1048576 && size < 2097152) {
          quality = 70;
        } else if (size >= 2097152 && size < 4194304) {
          quality = 60;
        } else if (size >= 4194304 && size < 4194304 * 2) {
          quality = 40;
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
