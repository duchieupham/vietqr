import 'dart:convert';

import '../../../commons/constants/env/env_config.dart';
import '../../../commons/enums/authentication_type.dart';
import '../../../commons/utils/base_api.dart';
import '../../../commons/utils/log.dart';
import '../../../models/connect_gg_chat_info_dto.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';

class ConnectGgChatRepository {
  String get userId => SharePrefUtils.getProfile().userId;
  Future<InfoGgChatDTO?> getInfoGgChat() async {
    try {
      String url =
          '${EnvConfig.getBaseUrl()}service/google-chat/information?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return InfoGgChatDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<bool?> addBankGgChat(String? webhookId, List<String> bankIds) async {
    try {
      Map<String, dynamic> param = {};
      param['id'] = webhookId;
      param['userId'] = userId;
      param['bankIds'] = bankIds;

      String url = '${EnvConfig.getBaseUrl()}service/google-chat/bank';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> removeBank(String? webhookId, String? bankId) async {
    try {
      Map<String, dynamic> param = {};
      param['id'] = webhookId;
      param['userId'] = userId;
      param['bankId'] = bankId;

      String url = '${EnvConfig.getBaseUrl()}service/google-chat/bank';
      final response = await BaseAPIClient.deleteAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> checkWebhookUrl(String? webhook) async {
    try {
      Map<String, dynamic> param = {};
      param['webhook'] = webhook;
      String url = '${EnvConfig.getBaseUrl()}service/google-chat/send-message';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> connectWebhook(List<String>? list, String? webhook) async {
    try {
      Map<String, dynamic> param = {};
      param['webhook'] = webhook;
      param['userId'] = userId;
      param['bankIds'] = list;

      String url = '${EnvConfig.getBaseUrl()}service/google-chat';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> deleteWebhook(String? id) async {
    try {
      Map<String, dynamic> param = {};
      param['id'] = id;
      String url = '${EnvConfig.getBaseUrl()}service/google-chat/remove';
      final response = await BaseAPIClient.deleteAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }
}
