import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/env/env_config.dart';
import 'interceptor/vietqr_interceptor.dart';

class DioClient {
  static FutureOr<Dio> setup(
      VietQRInterceptor interceptor, AppConfig appConfig) async {
    final options = BaseOptions(
      headers: <String, dynamic>{
        'Content-Type': 'application/json; charset=utf-8',
      },
      responseType: ResponseType.json,
      validateStatus: (status) => true,
      baseUrl: appConfig.getBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
    final dio = Dio(options);

    /// Unified add authentication request header
    dio.interceptors.add(interceptor);

    // /// Adapt data (according to your own data structure
    // /// , you can choose to add it)

    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (io.HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    /// Print Log if current is not release mode
    if (!appConfig.isProduct) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
      ));
    }

    return dio;
  }
}
