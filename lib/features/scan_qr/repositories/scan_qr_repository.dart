import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';

class ScanQrRepository {
  const ScanQrRepository();

  Future<BankTypeDTO> getBankTypeByCaiValue(String caiValue) async {
    BankTypeDTO result = const BankTypeDTO(
      id: '',
      bankCode: '',
      bankName: '',
      imageId: '',
      status: 0,
      caiValue: '',
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-type/cai/$caiValue';
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

  Future<String> getNickname(walletId) async {
    String nickName = '';
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/scan-result/$walletId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          nickName = data['nickname'];
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return nickName;
  }
}
