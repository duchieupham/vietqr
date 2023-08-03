import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:http/http.dart' as http;
import 'package:vierqr/models/response_message_dto.dart';

class DashboardRepository {
  const DashboardRepository();

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
          LOG.error('CAMERA PERMISSION after access: $cameraPermission');
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
      LOG.error('');
    }
    return result;
  }

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

  Future<ResponseMessageDTO> sendReport({
    List<XFile>? list,
    Map<String, dynamic>? data,
  }) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getUrl()}api/report';

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
}
