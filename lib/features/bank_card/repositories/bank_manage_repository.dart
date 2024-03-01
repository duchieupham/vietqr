import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/transaction_bank_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class BankManageRepository {
  const BankManageRepository();

  Future<void> getBankToken() async {
    try {
      String username = 'C7fzuZfRBTiwW8GNN7oX8fdAfuUGlcoA';
      String password = '66Abx39tpT8At0Vd';
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$username:$password'))}';
      final response = await BaseAPIClient.postAPI(
          url: '${EnvConfig.getBankUrl()}oauth2/v1/token',
          body: {'grant_type': 'client_credentials'},
          type: AuthenticationType.CUSTOM,
          header: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
            'Connection': 'keep-alive',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        await SharePrefUtils.saveBankToken(data['access_token']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Future<List<TransactionBankDTO>> getBankTransactions(String accountNumber,
      String accountType, String fromDate, String toDate) async {
    List<TransactionBankDTO> result = [];
    try {
      String bankToken = SharePrefUtils.getBankToken();
      const Uuid uuid = Uuid();
      final response = await BaseAPIClient.getAPI(
        url:
            '${EnvConfig.getBankUrl()}ms/ewallet/v1.0/get-transaction-history?accountNumber=$accountNumber&accountType=$accountType&fromDate=$fromDate&toDate=$toDate',
        header: {
          'Authorization': 'Bearer $bankToken',
          'ClientMessageId': uuid.v1(),
          'Content-Type': 'application/json',
        },
        type: AuthenticationType.CUSTOM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data['data']
            .map<TransactionBankDTO>(
                (json) => TransactionBankDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
