import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/detail_group_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class DetailGroupRepository {
  const DetailGroupRepository();

  Future<GroupDetailDTO> getDetail(String id) async {
    GroupDetailDTO result = GroupDetailDTO(banks: [], members: []);

    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}terminal/detail/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = GroupDetailDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<ResponseMessageDTO> removeMemberGroup(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal-member/remove';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
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

  Future<ResponseMessageDTO> addMemberGroup(Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}terminal-member';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
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

  Future<ResponseMessageDTO> addBankToGroup(Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/bank-account';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
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

  Future<ResponseMessageDTO> removeBankToGroup(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/bank-account';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
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
