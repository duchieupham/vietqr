import 'dart:io';

import 'package:path_provider/path_provider.dart';

extension StringExtension on String {
  Future<String> get getFullPathImagePath async {
    final directory = await getApplicationDocumentsDirectory();
    final localImagePath = '${directory.path}/$this';

    return localImagePath;
  }

  Future<File> get getImageFile async {
    return File(this);
  }
}
