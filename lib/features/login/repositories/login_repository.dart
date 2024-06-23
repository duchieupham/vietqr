import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/subjects.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/models/code_login_dto.dart';
import 'package:vierqr/models/info_user_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/user_profile.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../data/remotes/auth_api.dart';
import '../../../services/socket_service/socket_service.dart';

class LoginRepository {
  final AuthApi authApi;

  static final codeLoginController = BehaviorSubject<CodeLoginDTO>();

  LoginRepository({required this.authApi});

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
        UserProfile userProfile = UserProfile.fromJson(decodedToken);

        await SharePrefUtils.setTokenInfo(token);
        await SharePrefUtils.saveProfileToCache(userProfile);
        await SharePrefUtils.saveTokenFree('');
        await SharePrefUtils.saveTokenFCM(fcmToken);
        await SharePrefUtils.savePhone(dto.phoneNo);
        SocketService.instance.init();
        result = true;
      }
      // final res = await authApi.login(
      //   AuthenticationType.NONE,
      //   loginDTO.toJson(),
      // );

      // String token = res;
      // Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // UserProfile userProfile = UserProfile.fromJson(decodedToken);

      // await SharePrefUtils.setTokenInfo(token);
      // await SharePrefUtils.saveProfileToCache(userProfile);
      // await SharePrefUtils.saveTokenFree('');
      // await SharePrefUtils.saveTokenFCM(fcmToken);
      // await SharePrefUtils.savePhone(dto.phoneNo);
      // SocketService.instance.init();
      // result = true;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<bool> loginNFC(AccountLoginDTO dto) async {
    bool result = false;
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String url = '${getIt.get<AppConfig>().getBaseUrl}accounts/login';
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
        method: dto.method,
        cardNumber: dto.cardNumber,
        userId: dto.method == 'USER_ID' ? dto.userId : '',
      );
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: loginDTO.toJson(),
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        String token = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        UserProfile userProfile = UserProfile.fromJson(decodedToken);

        await SharePrefUtils.setTokenInfo(token);
        await SharePrefUtils.saveProfileToCache(userProfile);
        await SharePrefUtils.saveTokenFree('');
        await SharePrefUtils.saveTokenFCM(fcmToken);
        await SharePrefUtils.savePhone(dto.phoneNo);

        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future checkExistPhone(String phone) async {
    try {
      final response = await authApi.checkPhoneExist(
        type: AuthenticationType.NONE,
        phone: phone,
      );
      return InfoUserDTO.fromJson(response);
    } catch (e) {
      LOG.error(e.toString());
      rethrow;
    }
  }

  Future getFreeToken() async {
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}token_generate';

      Map<String, String>? result = {};
      result['Authorization'] = 'Basic ${StringUtils.instance.authBase64()}';
      result['Content-Type'] = 'application/json';
      result['Accept'] = '*/*';

      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.CUSTOM, body: {}, header: result);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await SharePrefUtils.saveTokenFree(data['access_token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<ResponseMessageDTO> forgotPass(body) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}accounts/password/reset';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.NONE,
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }
}
