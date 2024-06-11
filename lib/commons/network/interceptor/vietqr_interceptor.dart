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

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    AuthenticationType type = options.headers['type'];

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
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // debugPrint('>>>>> onError: ${err.response.toString()}');
    // debugPrint('>>>>> onError: ${err.type.toString()}');
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // debugPrint('>>>>> onResponse: ${response.data.toString()}');
    switch (response.statusCode) {
      case 401:
        throw UnauthorisedException(
          requestOptions: response.requestOptions,
          response: response,
        );
      case 500:
        throw DioError(
          requestOptions: response.requestOptions,
          type: DioErrorType.unknown,
          response: response,
        );
      default:
        // debugPrint('>>>>> ${response.statusCode}');
        break;
    }
    super.onResponse(response, handler);
  }
}
