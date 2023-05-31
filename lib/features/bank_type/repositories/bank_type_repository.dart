import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/pref_utils.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/user_repository.dart';

class BankTypeRepository {
  const BankTypeRepository();

  UserRepository get _userRes => UserRepository.instance;

  Future<List<BankTypeDTO>> getBankTypes() async {
    List<BankTypeDTO> listBanks = [];

    if (listBanks.isNotEmpty) {
      return listBanks;
    }
    try {
      String url = '${EnvConfig.getBaseUrl()}bank-type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listBanks = data
              .map<BankTypeDTO>((json) => BankTypeDTO.fromJson(json))
              .toList();
          _userRes.saveBanks(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listBanks;
  }
}
