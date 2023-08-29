import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/subjects.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/account_information_dto.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/code_login_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginRepository {
  static final codeLoginController = BehaviorSubject<CodeLoginDTO>();

  const LoginRepository();

  Future<bool> login(AccountLoginDTO dto) async {
    bool result = false;
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String url = '${EnvConfig.getBaseUrl()}accounts';
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      String platform = '';
      String device = '';
      String sharingCode = '';
      if (!PlatformUtils.instance.isWeb()) {
        if (PlatformUtils.instance.isIOsApp()) {
          platform = 'IOS';
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          device =
              '${iosInfo.name.toString()} ${iosInfo.systemVersion.toString()}';
        } else if (PlatformUtils.instance.isAndroidApp()) {
          platform = 'ANDROID';
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          device = androidInfo.model.toString();
        }
      } else {
        platform = 'Web';
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        device = webBrowserInfo.userAgent.toString();
      }
      AccountLoginDTO loginDTO = AccountLoginDTO(
        phoneNo: dto.phoneNo,
        password: dto.password,
        platform: platform,
        device: device,
        fcmToken: fcmToken,
        sharingCode: sharingCode,
      );
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: loginDTO.toJson(),
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        String token = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        AccountInformationDTO accountInformationDTO =
            AccountInformationDTO.fromJson(decodedToken);
        await AccountHelper.instance.setFcmToken(fcmToken);
        await AccountHelper.instance.setToken(token);
        await AccountHelper.instance.setTokenFree('');
        await UserInformationHelper.instance.setPhoneNo(dto.phoneNo);
        await UserInformationHelper.instance
            .setUserId(accountInformationDTO.userId);
        await UserInformationHelper.instance
            .setAccountInformation(accountInformationDTO);
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future checkExistPhone(String phone) async {
    try {
      String url = '${EnvConfig.getBaseUrl()}accounts/search/$phone';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return InfoUserDTO.fromJson(data);
        }
      } else {
        var data = jsonDecode(response.body);
        if (data != null) {
          return ResponseMessageDTO(
              status: data['status'], message: data['message']);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Future getFreeToken() async {
    try {
      String url = '${EnvConfig.getBaseUrl()}token_generate';

      Map<String, String>? result = {};
      result['Authorization'] = 'Basic ${StringUtils.instance.authBase64()}';
      result['Content-Type'] = 'application/json';
      result['Accept'] = '*/*';

      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.CUSTOM, body: {}, header: result);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await AccountHelper.instance.setTokenFree(data['access_token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }
}
