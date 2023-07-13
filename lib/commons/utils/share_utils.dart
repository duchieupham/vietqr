import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ShareUtils {
  const ShareUtils._privateConsrtructor();

  static const ShareUtils _instance = ShareUtils._privateConsrtructor();
  static ShareUtils get instance => _instance;

  Future<bool> shareImage(
      {required GlobalKey key, required String textSharing}) async {
    bool result = false;
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        final pngBytes = byteData.buffer.asUint8List();
        File('$tempPath/imgshare.png').writeAsBytesSync(pngBytes);
        XFile xFile = XFile('$tempPath/imgshare.png');
        List<XFile> files = []..add(xFile);
        await Share.shareXFiles(files, text: textSharing).then((value) async {
          File file = File('$tempPath/imgshare.png');
          await file.delete();
          result = true;
        });
      }
    } catch (e) {
      print('Error at saveWidgetToImage - ShareUtils: $e');
      LOG.error(e.toString());
    }
    return result;
  }

  Future<void> saveImageToGallery(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      await ImageGallerySaver.saveImage(
        pngBytes,
        quality: 100,
      );
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  String getTextSharing(QRGeneratedDTO dto) {
    String result = '';
    String prefix =
        '${dto.bankAccount}\n${dto.userBankName}\n${dto.bankCode} - ${dto.bankName}';
    String suffix = '';
    if (dto.amount.isNotEmpty && dto.amount != '0') {
      suffix =
          '\n${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND\n';
      if (dto.content.isNotEmpty) {
        suffix += dto.content;
      }
    }
    result = '$prefix$suffix\nĐược tạo bởi vietqr.vn - Hotline 19006234';
    return result;
  }
}
