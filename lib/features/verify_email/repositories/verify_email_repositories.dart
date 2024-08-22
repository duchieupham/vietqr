import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/key_free_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class EmailRepository {
  const EmailRepository();

  Future<ResponseMessageDTO> sendOTP(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}sendMailWithAttachment';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> confirmOTP(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}send-mail/confirm-otp';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<KeyFreeDTO> getKeyFree(Map<String, dynamic> param) async {
    KeyFreeDTO result = KeyFreeDTO(keyActive: '', bankId: '', status: 0);
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}key-active-bank/generate-key/back-up';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = KeyFreeDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

   Future<ResponseMessageDTO> requestOTP(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}accounts/request-otp';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

    Future<ResponseMessageDTO> confirmOTPInForgetPassword(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}accounts/confirm-otp';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
