import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/business_member_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BusinessMemberRepository {
  const BusinessMemberRepository();

  Future<dynamic> searchMember(String phoneNo) async {
    dynamic result;
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/search/$phoneNo';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        result = BusinessMemberDTO.fromJson(data);
      } else if (response.statusCode == 201) {
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }
}
