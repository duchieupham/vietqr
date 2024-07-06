import 'dart:convert';

import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/models/info_tele_dto.dart';

import '../../../commons/constants/env/env_config.dart';
import '../../../commons/enums/authentication_type.dart';
import '../../../commons/utils/base_api.dart';
import '../../../commons/utils/log.dart';
import '../../../models/connect_gg_chat_info_dto.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';

class ConnectGgChatRepository {
  String get userId => SharePrefUtils.getProfile().userId;

  Future<InfoMediaDTO?> getInfoMedia(TypeConnect type) async {
    try {
      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/information?userId=$userId';
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegram/information?userId=$userId';
          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/lark/information?userId=$userId';
          break;
        default:
      }

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return InfoMediaDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<bool?> addBankMedia(
      String? webhookId, List<String> bankIds, TypeConnect type) async {
    try {
      Map<String, dynamic> param = {};
      param['id'] = webhookId;
      param['userId'] = userId;
      param['bankIds'] = bankIds;

      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/bank';
          break;
        case TypeConnect.TELE:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark/bank';
          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/telegram/bank';
          break;
        default:
      }

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

  Future<bool?> removeBank(
      String? webhookId, String? bankId, TypeConnect type) async {
    try {
      Map<String, dynamic> param = {};
      param['id'] = webhookId;
      param['userId'] = userId;
      param['bankId'] = bankId;

      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/bank';
          break;
        case TypeConnect.TELE:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark/bank';
          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/telegram/bank';
          break;
        default:
      }

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

  Future<bool?> checkWebhookUrl(String? webhook, TypeConnect type) async {
    try {
      Map<String, dynamic> param = {};
      param['webhook'] = webhook;
      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/send-message';
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegram/send-message';
          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark/send-message';
          break;
        default:
      }

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

  Future<bool?> connectWebhook(String? webhook,
      {List<String>? list,
      List<String>? notificationTypes,
      List<String>? notificationContents,
      required TypeConnect type}) async {
    try {
      Map<String, dynamic> param = {};
      param['webhook'] = webhook;
      param['userId'] = userId;
      param['bankIds'] = list;
      param['notificationTypes'] = notificationTypes;
      param['notificationContents'] = notificationContents;

      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/google-chat';
          break;
        case TypeConnect.TELE:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/telegram';

          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark';
          break;
        default:
      }

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

  Future<bool?> deleteWebhook(String? id, TypeConnect type) async {
    try {
      Map<String, dynamic> param = {};
      param['id'] = id;
      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/remove';
          break;
        case TypeConnect.TELE:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/telegram/remove';
          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark/remove';
          break;
        default:
      }

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
