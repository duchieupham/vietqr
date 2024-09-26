import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/app_info_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/fcm_token_update_dto.dart';
import 'package:vierqr/models/introduce_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/setting_account_sto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class DashboardRepository {
  const DashboardRepository();

  String get userId => SharePrefUtils.getProfile().userId;

  //Request permissions
  Future<bool> requestPermissions() async {
    bool result = false;
    try {
      PermissionStatus cameraPermission = await Permission.camera.status;

      LOG.info('CAMERA PERMISSION: $cameraPermission');
      if (!cameraPermission.isGranted) {
        await Permission.camera.request().then((value) async {
          cameraPermission = await Permission.camera.status;
          LOG.error('CAMERA PERMISSION after access: $cameraPermission');
        });
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<bool> updateViewPopup(UserConfig userConfig) async {
    try {
      Map<String, dynamic> params = {};
      params['userConfig'] = userConfig.toJson();
      params['userId'] = userId;
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}accounts/setting/data-config';
      final response = await BaseAPIClient.postAPI(
        body: params,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool?> setNotificationMobile() async {
    try {
      Map<String, dynamic> params = {};
      params['notificationMobile'] = true;
      params['userId'] = userId;
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}accounts/setting/notification-mobile';
      final response = await BaseAPIClient.postAPI(
        body: params,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  //Check permissions
  Future<Map<String, PermissionStatus>> checkPermissions() async {
    Map<String, PermissionStatus> result = {};
    try {
      PermissionStatus cameraPermission = await Permission.camera.status;
      result['camera'] = cameraPermission;
    } catch (e) {
      LOG.error('');
    }
    return result;
  }

  Future<BankTypeDTO> getBankTypeByCaiValue(String caiValue) async {
    BankTypeDTO result = BankTypeDTO();
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}bank-type/cai/$caiValue';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BankTypeDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  NationalScannerDTO getNationalInformation(String value) {
    NationalScannerDTO result = const NationalScannerDTO(
      nationalId: '',
      oldNationalId: '',
      fullname: '',
      birthdate: '',
      gender: '',
      address: '',
      dateValid: '',
    );
    try {
      if (value.contains('|') && value.split('|').length == 7) {
        List<String> data = value.split('|');
        result = NationalScannerDTO(
          nationalId: data[0],
          oldNationalId: data[1],
          fullname: data[2],
          birthdate: TimeUtils.instance.convertDateString(data[3]),
          gender: data[4],
          address: data[5],
          dateValid: TimeUtils.instance.convertDateString(data[6]),
        );
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> sendReport({
    List<XFile>? list,
    Map<String, dynamic>? data,
  }) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getUrl}api/report';

      final List<http.MultipartFile> files = [];
      if (list != null) {
        for (var element in list) {
          final imageFile =
              await http.MultipartFile.fromPath('image', element.path);

          files.add(imageFile);
        }
      }
      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: data!,
        files: files,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }

    return result;
  }

  Future<IntroduceDTO> getPointAccount(String userId) async {
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}account-wallet/$userId';
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

  Future<AppInfoDTO> getVersionApp() async {
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}system-setting';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return AppInfoDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return AppInfoDTO();
  }

  //return
  //0: ignore
  //1: success
  //2: maintain
  //3: connection failed
  //4: token expired
  Future<int> checkValidToken() async {
    int result = 0;
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}token';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        result = 1;
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        result = 2;
      } else if (response.statusCode == 403) {
        result = 4;
      }
    } catch (e) {
      LOG.error(e.toString());
      if (e.toString().contains('Connection failed')) {
        result = 3;
      }
    }
    return result;
  }

  Future<bool> updateFcmToken() async {
    bool result = false;
    try {
      String userId = SharePrefUtils.getProfile().userId;
      String oldToken = SharePrefUtils.getTokenFCM();
      String newToken = await FirebaseMessaging.instance.getToken() ?? '';
      if (oldToken.trim() != newToken.trim()) {
        FcmTokenUpdateDTO dto = FcmTokenUpdateDTO(
            userId: userId, oldToken: oldToken, newToken: newToken);
        final String url =
            '${getIt.get<AppConfig>().getBaseUrl}fcm-token/update';
        final response = await BaseAPIClient.postAPI(
          url: url,
          body: dto.toJson(),
          type: AuthenticationType.SYSTEM,
        );
        if (response.statusCode == 200) {
          result = true;
          await SharePrefUtils.saveTokenFCM(newToken);
        }
      } else {
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
