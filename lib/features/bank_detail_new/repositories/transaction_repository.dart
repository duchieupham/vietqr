import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/trans_list_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class TransactionRepository extends BaseRepo {
  String get userId => SharePrefUtils.getProfile().userId;

  Future<TransData?> getListTrans({
    required String bankId,
    required String value,
    required String fromDate,
    required String toDate,
    required int type,
    required int page,
    required int size,
  }) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}transactions/list/v2?bankId=$bankId&userId=$userId&value=$value&fromDate=$fromDate&toDate=$toDate&type=$type&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = data['metadata'];
        return TransData.fromJson(data['data']);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }
}
