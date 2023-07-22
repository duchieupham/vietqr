import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/models/phone_book_dto.dart';

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
}
