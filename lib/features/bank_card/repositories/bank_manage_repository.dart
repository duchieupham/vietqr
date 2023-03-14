import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/account_balance_dto.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/transaction_bank_dto.dart';
import 'package:vierqr/services/shared_references/account_helper.dart';

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
        await AccountHelper.instance.setBankToken(data['access_token']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Future<AccountBalanceDTO> getAccountBalace(
      String customerId, String accountNumber) async {
    AccountBalanceDTO result = const AccountBalanceDTO(
      accountNumber: '',
      accountName: '',
      productName: '',
      acctCurrency: '',
      workingBalance: '',
    );
    try {
      const Uuid uuid = Uuid();
      final response = await BaseAPIClient.getAPI(
        url:
            '${EnvConfig.getBankUrl()}ms/bank-info/v1.0/get-all-account-list?customerId=$customerId&accountNumber=$accountNumber',
        header: {
          'Authorization': 'Bearer ${AccountHelper.instance.getBankToken()}',
          'ClientMessageId': uuid.v1(),
        },
        type: AuthenticationType.CUSTOM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<AccountBalanceDTO> list = data['data']
            .map<AccountBalanceDTO>((json) => AccountBalanceDTO.fromJson(json))
            .toList();
        result = list[0];
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<TransactionBankDTO>> getBankTransactions(String accountNumber,
      String accountType, String fromDate, String toDate) async {
    List<TransactionBankDTO> result = [];
    try {
      const Uuid uuid = Uuid();
      final response = await BaseAPIClient.getAPI(
        url:
            '${EnvConfig.getBankUrl()}ms/ewallet/v1.0/get-transaction-history?accountNumber=$accountNumber&accountType=$accountType&fromDate=$fromDate&toDate=$toDate',
        header: {
          'Authorization': 'Bearer ${AccountHelper.instance.getBankToken()}',
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
