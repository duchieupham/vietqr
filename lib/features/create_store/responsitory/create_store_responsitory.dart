import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/bank_account_terminal.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/store/merchant_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class CreateStoreRepository {
  const CreateStoreRepository();

  String get userId => SharePrefUtils.getProfile().userId;

  Future<String> getRandomCode() async {
    String result = '';

    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}terminal/generate-code';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data['data'];
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<List<BankAccountTerminal>> getListBankAccountTerminal(
      String userId, String terminalId) async {
    List<BankAccountTerminal> result = [];

    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/bank-account?terminalId=$terminalId&userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<BankAccountTerminal>((json) {
            return BankAccountTerminal.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> createStore(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}terminal';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
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

  Future<ResponseMessageDTO> createMerchant(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}merchant';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: param,
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

  Future<List<MerchantDTO>> getMerchants(int offset) async {
    List<MerchantDTO> result = [];
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}merchant/$userId?offset=$offset';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data.map<MerchantDTO>((json) {
          return MerchantDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
