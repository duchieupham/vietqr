import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/password_update_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';

class UserEditRepository {
  const UserEditRepository();

  Future<ResponseMessageDTO> updateUserInformation(UserProfile dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}user/information';

      final response = await BaseAPIClient.putAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode != 403) {
        var data = jsonDecode(response.body);
        await SharePrefUtils.saveProfileToCache(dto);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(
            status: Stringify.RESPONSE_STATUS_FAILED, message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<UserProfile> getUserInformation(String userId) async {
    UserProfile dto = UserProfile();
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}user/information/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        dto = UserProfile.fromJson(data);
        await SharePrefUtils.saveProfileToCache(dto);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return dto;
  }

  Future<Map<String, dynamic>> updatePassword(PasswordUpdateDTO dto) async {
    Map<String, dynamic> result = {'check': false, 'msg': ''};
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}user/password';
      PasswordUpdateDTO encryptedDTO = PasswordUpdateDTO(
        userId: dto.userId,
        oldPassword:
            EncryptUtils.instance.encrypted(dto.phoneNo, dto.oldPassword),
        newPassword:
            EncryptUtils.instance.encrypted(dto.phoneNo, dto.newPassword),
        phoneNo: dto.phoneNo,
      );
      final response = await BaseAPIClient.putAPI(
        url: url,
        body: encryptedDTO.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        result['check'] = true;
      } else {
        var data = jsonDecode(response.body);
        ResponseMessageDTO messageDTO = ResponseMessageDTO.fromJson(data);
        if (messageDTO.message == 'Old Password is not match.' ||
            messageDTO.message == 'E01') {
          result['msg'] = 'Mật khẩu cũ không khớp.';
        } else if (messageDTO.message == 'E182') {
          result['msg'] = 'Mật khẩu đã được sử dụng.';
        } else if (messageDTO.message == 'E162') {
          result['msg'] = 'Tài khoản đã được xác thực Email';
        } else {
          result['msg'] = messageDTO.message;
        }
        result['check'] = false;
      }
    } catch (e) {
      LOG.error(e.toString());
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
      final String url = '${getIt.get<AppConfig>().getBaseUrl}user/image';
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

  Future<ResponseMessageDTO> deactiveUser(String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}user/deactive/$userId';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: null,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        final String phone = SharePrefUtils.getPhone();

        List<InfoUserDTO> list =
            await SharePrefUtils.getLoginAccountList() ?? [];

        if (list.isNotEmpty) {
          list.removeWhere((element) => element.phoneNo == phone.trim());

          await SharePrefUtils.saveLoginAccountList(list);
        }

        await _resetServices();
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<ResponseMessageDTO> updateEmail(
      {required String email,
      required String userId}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}admin/account-email/$userId';
      final response = await BaseAPIClient.putAPI(
        url: url,
        body: {'email': email},
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        if (result.status == 'SUCCESS') {
          UserProfile profile = SharePrefUtils.getProfile();
          profile.email = email;
          profile.verify = false;
          await SharePrefUtils.saveProfileToCache(profile);
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

  Future<void> _resetServices() async {
    BuildContext context = NavigationService.context!;
    Provider.of<UserEditProvider>(context, listen: false).reset();
    await SharePrefUtils.saveProfileToCache(UserProfile());
    await SharePrefUtils.setTokenInfo('');
    await SharePrefUtils.setTokenInfo('');
  }
}
