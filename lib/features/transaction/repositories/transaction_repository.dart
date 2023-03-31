import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/business_detail_dto.dart';
import 'package:vierqr/models/transaction_branch_input_dto.dart';

class TransactionRepository {
  const TransactionRepository();

  Future<List<BusinessTransactionDTO>> getTransactionByBranchId(
      TransactionBranchInputDTO dto) async {
    List<BusinessTransactionDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}transaction-branch';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = data
            .map<BusinessTransactionDTO>(
                (json) => BusinessTransactionDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
