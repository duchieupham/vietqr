import 'dart:convert';

import 'package:dio/dio.dart';
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

  Future<bool?> updateUrl({
    required String url,
    required TypeConnect type,
    required String id,
  }) async {
    try {
      Map<String, dynamic> param = {};
      String url = '';
      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chats/update-webhook/$id';
          param['webhook'] = url;
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegrams/update-chatId/$id';
          param['chatId'] = url;

          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/larks/update-webhook/$id';
          param['webhook'] = url;
          break;
        default:
      }

      final response = await BaseAPIClient.putAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );

      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> updateSharingInfo({
    required TypeConnect type,
    required List<String> notificationTypes,
    required List<String> notificationContents,
    required String id,
  }) async {
    try {
      Map<String, dynamic> param = {};
      String url = '';
      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chats/update-configure';
          param['googleChatId'] = id;
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegrams/update-configure';
          param['telegramId'] = id;

          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/larks/update-configure';
          param['larkId'] = id;

          break;
        default:
      }

      param['notificationTypes'] = notificationTypes;
      param['notificationContents'] = notificationContents;

      final response = await BaseAPIClient.putAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );

      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<InfoMediaDTO?> getInfoMedia(TypeConnect type) async {
    try {
      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chats/information-detail?userId=$userId';
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegrams/information-detail?userId=$userId';
          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/larks/information-detail?userId=$userId';
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
          return InfoMediaDTO.fromJson(data, type);
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
      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/send-message';
          Map<String, dynamic> param = {};
          param['webhook'] = webhook;
          final response = await BaseAPIClient.postAPI(
            body: param,
            url: url,
            type: AuthenticationType.SYSTEM,
          );
          return response.statusCode == 200;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegram/send-message?chatId=$webhook';
          final response = await BaseAPIClient.getAPI(
            url: url,
            type: AuthenticationType.SYSTEM,
          );
          return response.statusCode == 200;

        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/lark/send-message?webhook=$webhook';
          final response = await BaseAPIClient.getAPI(
            url: url,
            type: AuthenticationType.SYSTEM,
          );
          return response.statusCode == 200;
        default:
          break;
      }
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
      switch (type) {
        case TypeConnect.GG_CHAT:
          param['webhook'] = webhook;
          break;
        case TypeConnect.TELE:
          param['chatId'] = webhook;
          break;
        case TypeConnect.LARK:
          param['webhook'] = webhook;
          break;
        default:
      }
      param['userId'] = userId;
      param['bankIds'] = list;
      param['notificationTypes'] = notificationTypes;
      param['notificationContents'] = notificationContents;

      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/google-chats';
          break;
        case TypeConnect.TELE:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/telegrams';

          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/larks';
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
      if (type == TypeConnect.GG_CHAT) {
        param['id'] = id;
      }
      String url = '';
      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/remove';
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegram/remove?id=$id';
          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/lark/remove?id=$id';
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
