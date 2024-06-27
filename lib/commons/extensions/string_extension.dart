import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../constants/env/env_config.dart';
import '../di/injection/injection.dart';

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

  String get getPathIMageNetwork {
    return '${getIt.get<AppConfig>().getBaseUrl}images/$this';
  }
}
