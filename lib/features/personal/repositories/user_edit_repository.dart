import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/password_update_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/create_qr_page_select_provider.dart';
import 'package:vierqr/services/providers/create_qr_provider.dart';
import 'package:vierqr/services/providers/suggestion_widget_provider.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/event_bloc_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:http/http.dart' as http;

class UserEditRepository {
  const UserEditRepository();

  Future<ResponseMessageDTO> updateUserInformation(
      AccountInformationDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/information';
      final response = await BaseAPIClient.putAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode != 403) {
        var data = jsonDecode(response.body);
        UserInformationHelper.instance.setAccountInformation(dto);
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

  Future<AccountInformationDTO> getUserInformation(String userId) async {
    AccountInformationDTO accountInformationDTO = const AccountInformationDTO(
      userId: '',
      firstName: '',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 0,
      address: '',
      email: '',
      imgId: '',
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/information/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accountInformationDTO = AccountInformationDTO.fromJson(data);
        UserInformationHelper.instance
            .setAccountInformation(accountInformationDTO);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return accountInformationDTO;
  }

  Future<Map<String, dynamic>> updatePassword(PasswordUpdateDTO dto) async {
    Map<String, dynamic> result = {'check': false, 'msg': ''};
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/password';
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

  Future<ResponseMessageDTO> deactiveUser(String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}user/deactive/$userId';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: null,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
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

  Future<void> _resetServices() async {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<CreateQRPageSelectProvider>(context, listen: false).reset();
    Provider.of<BankAccountProvider>(context, listen: false).reset();
    Provider.of<UserEditProvider>(context, listen: false).reset();
    Provider.of<SuggestionWidgetProvider>(context, listen: false).reset();
    await EventBlocHelper.instance.updateLogoutBefore(true);
    await UserInformationHelper.instance.initialUserInformationHelper();
    await AccountHelper.instance.setBankToken('');
    await AccountHelper.instance.setToken('');
  }
}
