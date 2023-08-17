import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class ContactRepository {
  Future<List<ContactDTO>> getListSaveContact(userId) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/list-approved/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<List<ContactDTO>> getListContactPending(userId) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/list-pending/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<ContactDetailDTO> getContactDetail(id) async {
    ContactDetailDTO dto = ContactDetailDTO();
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          dto = ContactDetailDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return dto;
  }

  Future<ResponseMessageDTO> removeContact(String id) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/remove/$id';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<ResponseMessageDTO> updateContact(query) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/update';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: query,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }

  Future<ResponseMessageDTO> updateStatusContact(query) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/status';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: query,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
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

  Future<List<ContactDTO>> getListContactRecharge(userId) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/recharge?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<List<ContactDTO>> searchUser(String phoneNo) async {
    List<ContactDTO> list = [];
    try {
      String url = '${EnvConfig.getBaseUrl()}accounts/list/search/$phoneNo';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>((json) => ContactDTO(
                  imgId: json['imgId'],
                  id: json['id'],
                  carrierTypeId: json['carrierTypeId'],
                  nickname:
                      '${json['lastName']} ${json['middleName']} ${json['firstName']}',
                  status: 0,
                  type: 0,
                  description: '',
                  phoneNo: json['phoneNo']))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
      return list;
    }
    return list;
  }
}
