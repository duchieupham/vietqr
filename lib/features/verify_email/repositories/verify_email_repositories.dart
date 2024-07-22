import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/response_message_dto.dart';

class EmailRepository {
  const EmailRepository();

  Future<ResponseMessageDTO> sendOTP(Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      const String url =
          'https://dev.vietqr.org/vqr/api/sendMailWithAttachment';
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
}
