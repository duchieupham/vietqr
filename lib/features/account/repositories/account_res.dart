import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

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
        UserInformationHelper.instance.setWalletInfo(response.body);
        return IntroduceDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return IntroduceDTO();
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
            await UserInformationHelper.instance.setImageId(result.message);
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

  Future<AccountInformationDTO> getUserInformation(String userId) async {
    AccountInformationDTO result = AccountInformationDTO(
        userId: '',
        firstName: '',
        middleName: '',
        lastName: '',
        birthDate: '',
        gender: 0,
        address: '',
        email: '',
        imgId: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/information/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = AccountInformationDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<SettingAccountDTO> getSettingAccount(String userId) async {
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
}
