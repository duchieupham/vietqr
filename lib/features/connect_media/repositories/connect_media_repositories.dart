import 'dart:convert';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/connect_media/connect_media_screen.dart';
import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/B%C4%90SD/discord_dto.dart';
import 'package:vierqr/models/B%C4%90SD/gg_chat_dto.dart';
import 'package:vierqr/models/B%C4%90SD/gg_sheet_dto.dart';
import 'package:vierqr/models/B%C4%90SD/lark_dto.dart';
import 'package:vierqr/models/B%C4%90SD/slack_dto.dart';
import 'package:vierqr/models/B%C4%90SD/tele_dto.dart';
import 'package:vierqr/models/metadata_dto.dart';
import '../../../commons/constants/env/env_config.dart';
import '../../../commons/enums/authentication_type.dart';
import '../../../commons/utils/base_api.dart';
import '../../../commons/utils/log.dart';
import '../../../models/connect_gg_chat_info_dto.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';

class ConnectGgChatRepository extends BaseRepo {
  String get userId => SharePrefUtils.getProfile().userId;

  Future<bool?> updateUrl({
    required String webhook,
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
          param['webhook'] = webhook;
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegrams/update-chatId/$id';
          param['chatId'] = webhook;

          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/larks/update-webhook/$id';
          param['webhook'] = webhook;
          break;
        case TypeConnect.SLACK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/slacks/update-webhook/$id';
          param['webhook'] = webhook;
          break;
        case TypeConnect.DISCORD:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/discords/update-webhook/$id';
          param['webhook'] = webhook;
          break;
        case TypeConnect.GG_SHEET:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/update-webhook/$id';
          param['webhook'] = webhook;
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
        case TypeConnect.SLACK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/slacks/update-configure';
          param['slackId'] = id;
          break;
        case TypeConnect.DISCORD:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/discords/update-configure';
          param['discordId'] = id;
          break;
        case TypeConnect.GG_SHEET:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/update-configure';
          param['googleSheetId'] = id;
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

  Future<InfoMediaDTO?> getInfoMedia(TypeConnect type, String id) async {
    try {
      String url = '';

      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chats/information-detail?id=$id';
          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegrams/information-detail?id=$id';
          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/larks/information-detail?id=$id';
          break;
        case TypeConnect.SLACK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/slacks/information-detail?id=$id';
          break;
        case TypeConnect.DISCORD:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/discords/information-detail?id=$id';
          break;
        case TypeConnect.GG_SHEET:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/information-detail?id=$id';
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
          url = '${getIt.get<AppConfig>().getBaseUrl}service/telegram/bank';
          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark/bank';
          break;
        case TypeConnect.SLACK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/slacks/bank';
          break;
        case TypeConnect.DISCORD:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/discords/bank';
          break;
        case TypeConnect.GG_SHEET:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/bank';
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
          url = '${getIt.get<AppConfig>().getBaseUrl}service/telegram/bank';
          break;
        case TypeConnect.LARK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark/bank';
          break;
        case TypeConnect.SLACK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/slacks/bank';
          break;
        case TypeConnect.DISCORD:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/discords/bank';
          break;
        case TypeConnect.GG_SHEET:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/bank';
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

  Future<List<GoogleSheetDTO>> getGgSheetList({
    required int page,
    required int size,
  }) async {
    List<GoogleSheetDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/list?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data['metadata']);

        result = data['data'].map<GoogleSheetDTO>((json) {
          return GoogleSheetDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<DiscordDTO>> getDiscordList({
    required int page,
    required int size,
  }) async {
    List<DiscordDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}service/discords/list?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data['metadata']);

        result = data['data'].map<DiscordDTO>((json) {
          return DiscordDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<SlackDTO>> getSlackList({
    required int page,
    required int size,
  }) async {
    List<SlackDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}service/slacks/list?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data['metadata']);

        result = data['data'].map<SlackDTO>((json) {
          return SlackDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TeleDTO>> getTeleList({
    required int page,
    required int size,
  }) async {
    List<TeleDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}service/telegrams/list?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data['metadata']);

        result = data['data'].map<TeleDTO>((json) {
          return TeleDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<LarkDTO>> getLarkList({
    required int page,
    required int size,
  }) async {
    List<LarkDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}service/larks/list?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data['metadata']);

        result = data['data'].map<LarkDTO>((json) {
          return LarkDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<GoogleChatDTO>> getChatList({
    required int page,
    required int size,
  }) async {
    List<GoogleChatDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}service/google-chats/list?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data['metadata']);
        result = data['data'].map<GoogleChatDTO>((json) {
          return GoogleChatDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
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

        case TypeConnect.SLACK:
          Map<String, dynamic> param = {};
          param['webhook'] = webhook;
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/slacks/send-message';
          final response = await BaseAPIClient.postAPI(
            body: param,
            url: url,
            type: AuthenticationType.SYSTEM,
          );
          return response.statusCode == 200;
        case TypeConnect.DISCORD:
          Map<String, dynamic> param = {};
          param['webhook'] = webhook;
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/discords/send-message';
          final response = await BaseAPIClient.postAPI(
            body: param,
            url: url,
            type: AuthenticationType.SYSTEM,
          );
          return response.statusCode == 200;
        case TypeConnect.GG_SHEET:
          Map<String, dynamic> param = {};
          param['webhook'] = webhook;
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/send-message';
          final response = await BaseAPIClient.postAPI(
            body: param,
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

  Future<bool?> connectWebhook(String? webhook, String? name,
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
        case TypeConnect.SLACK:
          param['webhook'] = webhook;
          break;
        case TypeConnect.DISCORD:
          param['webhook'] = webhook;
          break;
        case TypeConnect.GG_SHEET:
          param['webhook'] = webhook;
          break;
        default:
      }
      param['name'] = name ?? webhook;
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
        case TypeConnect.SLACK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/slacks';
          break;
        case TypeConnect.DISCORD:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/discords';
          break;
        case TypeConnect.GG_SHEET:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets';
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

      String url = '';
      switch (type) {
        case TypeConnect.GG_CHAT:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-chat/remove';
          param['id'] = id;

          break;
        case TypeConnect.TELE:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/telegram/remove?id=$id';
          break;
        case TypeConnect.LARK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/lark/remove?id=$id';
          break;
        case TypeConnect.SLACK:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/lark/remove';
          param['id'] = id;
          break;
        case TypeConnect.DISCORD:
          url = '${getIt.get<AppConfig>().getBaseUrl}service/discords/remove';
          param['id'] = id;
          break;
        case TypeConnect.GG_SHEET:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}service/google-sheets/remove';
          param['id'] = id;
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
