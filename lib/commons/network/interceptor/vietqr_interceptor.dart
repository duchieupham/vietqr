import 'package:dio/dio.dart';

import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';
import '../../enums/authentication_type.dart';
import '../exceptions/vietqr_exception.dart';

class VietQRInterceptor extends InterceptorsWrapper {
  VietQRInterceptor();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String token = await SharePrefUtils.getTokenInfo();
    String tokenFree = SharePrefUtils.getTokenFree();

    AuthenticationType type = options.headers['type'];
    String bearerToken = options.headers['bearerToken'] ?? '';

    if (bearerToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $bearerToken';
      options.headers.remove('bearerToken');
    }

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    switch (type) {
      case AuthenticationType.SYSTEM:
        options.headers['Authorization'] =
            'Bearer ${(tokenFree.isNotEmpty) ? tokenFree : token}';
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = '*/*';
        break;
      case AuthenticationType.NONE:
      case AuthenticationType.CUSTOM:
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept'] = '*/*';
        break;
      default:
        break;
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // debugPrint('>>>>> onError: ${err.response.toString()}');
    // debugPrint('>>>>> onError: ${err.type.toString()}');
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // debugPrint('>>>>> onResponse: ${response.data.toString()}');
    int? statusCode = response.statusCode ?? 0;
    if (statusCode >= 200 && statusCode <= 299) {
      super.onResponse(response, handler);
      return;
    }

    switch (statusCode) {
      case 401:
        throw UnauthorisedException(
          requestOptions: response.requestOptions,
          response: response,
        );
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          type: DioExceptionType.unknown,
          response: response,
        );
    }
  }
}
