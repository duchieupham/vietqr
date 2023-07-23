import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/models/phone_book_detail_dto.dart';
import 'package:vierqr/models/phone_book_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class PhoneBookRepository {
  Future<List<PhoneBookDTO>> getListSavePhoneBook(userId) async {
    List<PhoneBookDTO> list = [];
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
              .map<PhoneBookDTO>((json) => PhoneBookDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      print('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<List<PhoneBookDTO>> getListPhoneBookPending(userId) async {
    List<PhoneBookDTO> list = [];
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
              .map<PhoneBookDTO>((json) => PhoneBookDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      print('Error at requestPermissions - PermissionRepository: $e');
    }
    return list;
  }

  Future<PhoneBookDetailDTO> getPhoneBookDetail(id) async {
    PhoneBookDetailDTO dto = PhoneBookDetailDTO();
    try {
      String url = '${EnvConfig.getBaseUrl()}contact/$id';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          dto = PhoneBookDetailDTO.fromJson(data);
        }
      }
    } catch (e) {
      print('Error at requestPermissions - PermissionRepository: $e');
    }
    return dto;
  }

  Future<ResponseMessageDTO> removePhoneBook(String id) async {
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
      print('Error at requestPermissions - PermissionRepository: $e');
    }
    return result;
  }
}
