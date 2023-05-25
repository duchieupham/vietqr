import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';

class ImageUtils {
  const ImageUtils._privateConsrtructor();

  static const ImageUtils _instance = ImageUtils._privateConsrtructor();
  static ImageUtils get instance => _instance;

  //
  NetworkImage getImageNetWork(String imageId) {
    return NetworkImage(
      '${EnvConfig.getBaseUrl()}images/$imageId',
      headers: {"Authorization": 'Bearer ${AccountHelper.instance.getToken()}'},
      scale: 1.0,
    );
  }

  CachedNetworkImageProvider getImageNetworkCache(String imageId) {
    return CachedNetworkImageProvider(
      '${EnvConfig.getBaseUrl()}images/$imageId',
      headers: {"Authorization": 'Bearer ${AccountHelper.instance.getToken()}'},
      cacheKey: const Uuid().v4(),
    );
  }
}
