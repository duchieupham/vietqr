import 'dart:convert';

import 'package:vierqr/commons/constants/configurations/numeral.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:http/http.dart' as http;

class BaseAPIClient {
  static final String _bankToken = AccountHelper.instance.getBankToken();
  static final String _token = AccountHelper.instance.getToken();
  static const Duration _timeout =
      Duration(seconds: Numeral.DEFAULT_TIMEOUT_API);

  const BaseAPIClient();

  static Future<http.Response> getAPI({
    required String url,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    final http.Response result = await http
        .get(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> postAPI({
    required String url,
    required dynamic body,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    _removeBodyNullValues(body);
    final http.Response result = await http
        .post(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> putAPI({
    required String url,
    required dynamic body,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    _removeBodyNullValues(body);
    final http.Response result = await http
        .put(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
      body: jsonEncode(body),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> deleteAPI({
    required String url,
    required dynamic body,
    AuthenticationType? type,
    Map<String, String>? header,
  }) async {
    _removeBodyNullValues(body);
    final http.Response result = await http
        .delete(
      Uri.parse(url),
      headers: _getHeader(type: type, header: header),
      body: jsonEncode(body),
    )
        .timeout(_timeout, onTimeout: () {
      final http.Response response = http.Response('Request Timeout', 408);
      logAPI(url: url, statusCode: response.statusCode, body: response.body);
      return response;
    });
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Future<http.Response> postMultipartAPI({
    required String url,
    required Map<String, dynamic> fields,
    required List<http.MultipartFile> files,
  }) async {
    final Uri uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $_token';
    if (fields.isNotEmpty) {
      for (String key in fields.keys) {
        request.fields[key] = fields[key];
      }
    }
    if (files.isNotEmpty) {
      for (http.MultipartFile multipartFile in files) {
        request.files.add(multipartFile);
      }
    }
    final http.Response result =
        await http.Response.fromStream(await request.send());
    logAPI(url: url, statusCode: result.statusCode, body: result.body);
    return result;
  }

  static Map<String, String>? _getHeader(
      {AuthenticationType? type,
      Map<String, String>? header,
      String? clientMessageId}) {
    Map<String, String>? result = {};
    type ??= AuthenticationType.NONE;
    switch (type) {
      case AuthenticationType.BANK:
        result['Authorization'] = 'Bearer $_bankToken';
        result['Content-Type'] = 'application/json';
        result['ClientMessageId'] = clientMessageId!;
        result['Accept'] = '*/*';
        break;
      case AuthenticationType.SYSTEM:
        result['Authorization'] = 'Bearer $_token';
        result['Content-Type'] = 'application/json';
        result['Accept'] = '*/*';
        break;
      case AuthenticationType.NONE:
        result['Content-Type'] = 'application/json';
        result['Accept'] = '*/*';
        break;
      case AuthenticationType.CUSTOM:
        result = header;
        break;
      default:
        break;
    }
    return result;
  }

  static void _removeBodyNullValues(body) {
    if (body is Map<String, dynamic>) {
      body.removeWhere(_isMapValueNull);
    } else if (body is List<Map<String, dynamic>>) {
      for (var element in body) {
        element.removeWhere(_isMapValueNull);
      }
    }
  }

  static bool _isMapValueNull(String _, dynamic value) =>
      value == null && value is! String;

  static void logAPI(
      {required String url, required int statusCode, required String body}) {
    String message = 'URL: $url - STATUS CODE: $statusCode\nRESPONSE: $body';
    if (statusCode >= 200 && statusCode <= 299) {
      LOG.info(message);
    } else {
      LOG.error(message);
    }
  }
}
