import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class ImageUtils {
  const ImageUtils._privateConstructor();

  static const ImageUtils _instance = ImageUtils._privateConstructor();

  static ImageUtils get instance => _instance;

  String get token => SharePrefUtils.tokenInfo;

  //
  NetworkImage getImageNetWork(String imageId) {
    return NetworkImage(
      '${getIt.get<AppConfig>().getBaseUrl}images/$imageId',
      headers: {"Authorization": 'Bearer $token'},
      scale: 1.0,
    );
  }

  CachedNetworkImageProvider getImageNetworkCache(String imageId) {
    return CachedNetworkImageProvider(
      '${getIt.get<AppConfig>().getBaseUrl}images/$imageId',
      headers: {"Authorization": 'Bearer $token'},
      cacheKey: const Uuid().v4(),
    );
  }
}
