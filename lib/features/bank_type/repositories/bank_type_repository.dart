import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BankTypeRepository {
  const BankTypeRepository();

  Future<List<BankTypeDTO>> getBankTypes() async {
    List<BankTypeDTO> listBanks = [];

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
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listBanks;
  }

  Future<List<BankTypeDTO>> getBankTypesAuthen() async {
    List<BankTypeDTO> listBanks = [];

    try {
      String url = '${EnvConfig.getBaseUrl()}bank-type/unauthenticated';
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
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listBanks;
  }

  Future<ResponseMessageDTO> requestRegisterBankAccount(
      Map<String, dynamic> param) async {
    ResponseMessageDTO dto = ResponseMessageDTO(status: '', message: '');

    try {
      String url = '${EnvConfig.getBaseUrl()}account-bank-request';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          dto = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return dto;
  }
}
