import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/contact_detail_dto.dart';
import 'package:vierqr/models/contact_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class ContactRepository {
  Future<List<ContactDTO>> getListSaveContact(userId, type, offset) async {
    List<ContactDTO> list = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}contact/list?userId=$userId&type=$type&offset=$offset';

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
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}contact/list-pending/$userId';
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
      String url = '${getIt.get<AppConfig>().getBaseUrl}contact/$id';
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
      String url = '${getIt.get<AppConfig>().getBaseUrl}contact/remove/$id';
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

  Future<ResponseMessageDTO> updateContact(query, File? file) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    final List<http.MultipartFile> files = [];
    if (file != null) {
      final imageFile = await http.MultipartFile.fromPath('image', file.path);
      files.add(imageFile);
    }
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}contact-qr/update';
      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: query,
        files: files,
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

  Future<ResponseMessageDTO> updateContactVCard(query, File? file) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    final List<http.MultipartFile> files = [];
    if (file != null) {
      final imageFile = await http.MultipartFile.fromPath('image', file.path);
      files.add(imageFile);
    }
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}contacts/vcard/update';
      final response = await BaseAPIClient.postMultipartAPI(
        url: url,
        fields: query,
        files: files,
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

  Future<ResponseMessageDTO> updateRelation(query) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}contact/relation';
      final response = await BaseAPIClient.postAPI(
          url: url, body: query, type: AuthenticationType.SYSTEM);
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
      String url = '${getIt.get<AppConfig>().getBaseUrl}contact/status';
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

  Future<List<ContactDTO>> getListContactRecharge(userId) async {
    List<ContactDTO> list = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}contact/recharge?userId=$userId';
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
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}accounts/list/search/$phoneNo';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          list = data
              .map<ContactDTO>(
                (json) => ContactDTO(
                  imgId: json['imgId'],
                  id: json['id'],
                  carrierTypeId: json['carrierTypeId'],
                  nickname:
                      '${json['lastName']} ${json['middleName']} ${json['firstName']}',
                  status: 0,
                  type: 0,
                  description: '',
                  phoneNo: json['phoneNo'],
                  relation: json['relation'],
                ),
              )
              .toList();
        }
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
      return list;
    }
    return list;
  }

  Future<ResponseMessageDTO> insertVCard(List<VCardModel> list,
      {String? token, String? tokenFree}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}contacts/vcard';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {'list': list},
        token: token,
        tokenFree: tokenFree,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: '');
      }
    } catch (e) {
      LOG.error('Error at requestPermissions - PermissionRepository: $e');
      return result;
    }
    return result;
  }

  Future<List<ContactDTO>> searchContact(nickname, userId, type, offset) async {
    List<ContactDTO> list = [];
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}contacts/search';

      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {
          'nickname': nickname,
          'userId': userId,
          'type': type,
          'offset': offset,
        },
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
}
