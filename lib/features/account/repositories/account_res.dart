import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/models/card_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/models/theme_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/socket_service/socket_service.dart';

class AccountRepository {
  const AccountRepository();

  Future<IntroduceDTO> getPointAccount(String userId) async {
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-wallet/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        IntroduceDTO introduceDTO = IntroduceDTO.fromJson(data);
        await SharePrefUtils.saveWalletInfo(introduceDTO);
        return introduceDTO;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return IntroduceDTO();
  }

  Future<ResponseMessageDTO> updateKeepBright(String userId, bool value) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/setting/screen';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {
          'value': value,
          'userId': userId,
        },
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
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

  Future<ResponseMessageDTO> updateAvatar(
      String imgId, String userId, File? file) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final Map<String, dynamic> data = {
        'userId': userId,
        'imgId': imgId,
      };
      final String url = '${EnvConfig.getBaseUrl()}user/image';
      final List<http.MultipartFile> files = [];
      if (file != null) {
        final imageFile = await http.MultipartFile.fromPath('image', file.path);
        files.add(imageFile);
        final response = await BaseAPIClient.postMultipartAPI(
          url: url,
          fields: data,
          files: files,
        );
        if (response.statusCode == 200 || response.statusCode == 400) {
          var data = jsonDecode(response.body);
          result = ResponseMessageDTO.fromJson(data);
          if (result.message.trim().isNotEmpty) {
            UserProfile profile = SharePrefUtils.getProfile();
            profile.imgId = result.message;
            await SharePrefUtils.saveProfileToCache(profile);
          }
        } else {
          result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<UserProfile?> getUserInformation(String userId) async {
    UserProfile result = UserProfile();
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/information/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = UserProfile.fromJson(data);
      } else if (response.statusCode == 403) {
        return null;
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<SettingAccountDTO?> getSettingAccount(String userId) async {
    SettingAccountDTO result = SettingAccountDTO();
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/setting/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = SettingAccountDTO.fromJson(data);
      } else if (response.statusCode == 403) {
        return null;
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<bool> updateVoiceSetting(Map<String, dynamic> param) async {
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/setting/voice';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      LOG.error(e.toString());
      return false;
    }
    return false;
  }

  Future<CardDTO> getCardID(String userId) async {
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}accounts/cardNumber?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return CardDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return CardDTO();
  }

  Future<ResponseMessageDTO> updateCardID(
      String userId, String cardNumber, String cardType) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');

    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/cardNumber';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {
          'userId': userId,
          'cardNumber': cardNumber,
          'cardType': cardType,
        },
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

  Future<ResponseMessageDTO> updateTheme(String userId, int value) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');

    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/setting/theme';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {'value': value, 'userId': userId},
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

  Future<bool> logout() async {
    bool result = false;
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/logout';
      // String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      final String fcmToken = await SharePrefUtils.getTokenInfo();
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'fcmToken': fcmToken},
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        result = true;
        SocketService.instance.closeListenTransaction();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<ThemeDTO>> getListTheme() async {
    try {
      final String url = '${EnvConfig.getBaseUrl()}theme/list';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return data.map<ThemeDTO>((json) {
            return ThemeDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return [];
  }
}
