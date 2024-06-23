import 'dart:io';

import 'package:path_provider/path_provider.dart';

extension StringExtension on String {
  Future<String> get getFullPathImagePath async {
    final directory = await getApplicationDocumentsDirectory();
    final localImagePath = '${directory.path}/$this';

    return localImagePath;
  }

  Future<File> get getImageFile async {
    final file = File(this);
    if (await file.exists()) {
      return file;
    }
    return File('');
  }
}
