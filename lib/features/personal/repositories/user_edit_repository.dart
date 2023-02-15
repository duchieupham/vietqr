import 'dart:convert';

import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/password_update_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

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
}
