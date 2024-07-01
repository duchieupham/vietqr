import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

import '../../../models/response_message_dto.dart';

class HomeRepository {
  const HomeRepository();

  //Request permissions
  Future<bool> requestPermissions() async {
    bool result = false;
    try {
      // PermissionStatus smsPermission = await Permission.sms.status;
      PermissionStatus cameraPermission = await Permission.camera.status;
      // if (!smsPermission.isGranted) {
      //   await Permission.sms.request();
      // }

      LOG.info('CAMERA PERMISSION: $cameraPermission');
      if (!cameraPermission.isGranted) {
        await Permission.camera.request().then((value) async {
          cameraPermission = await Permission.camera.status;
        });
      }

      // if (smsPermission.isGranted && cameraPermission.isGranted) {
      //   result = true;
      // }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  //Check permissions
  Future<Map<String, PermissionStatus>> checkPermissions() async {
    Map<String, PermissionStatus> result = {};
    try {
      // PermissionStatus smsPermission = await Permission.sms.status;
      PermissionStatus cameraPermission = await Permission.camera.status;
      // result['sms'] = smsPermission;
      result['camera'] = cameraPermission;
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<BankTypeDTO> getBankTypeByCaiValue(String caiValue) async {
    BankTypeDTO result = BankTypeDTO();
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}bank-type/cai/$caiValue';
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

  Future<ResponseMessageDTO> voiceTransaction(
      Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}voice/transaction';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
