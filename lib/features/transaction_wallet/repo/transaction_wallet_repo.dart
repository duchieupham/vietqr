import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';

import '../../../models/trans_wallet_dto.dart';

class TransactionWalletRepository {
  const TransactionWalletRepository();

  Future<List<TransWalletDto>> getTrans(Map<String, dynamic> param) async {
    List<TransWalletDto> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transaction-wallet?userId=${param['userId']}&status=${param['status']}&offset=${param['offset']}';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<TransWalletDto>((json) => TransWalletDto.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
