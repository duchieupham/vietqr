import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_account_remove_dto.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BankCardRepository {
  const BankCardRepository();

  Future<ResponseMessageDTO> insertBankCard(BankCardInsertDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<List<BankAccountDTO>> getListBankAccount(String userId) async {
    List<BankAccountDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank/$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<BankAccountDTO>((json) => BankAccountDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> removeBankAccount(BankAccountRemoveDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
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

  Future<ResponseMessageDTO> removeMemberFromBankAccount(
      String bankId, String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}account-bank/remove';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: {'bankId': bankId, 'userId': userId},
        type: AuthenticationType.SYSTEM,
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
  //
}
