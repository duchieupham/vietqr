import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/store/merchant_dto.dart';
import 'package:vierqr/models/store/store_dto.dart';
import 'package:vierqr/models/store/total_store_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class StoreRepository {
  const StoreRepository();

  String get userId => SharePrefUtils.getProfile().userId;

  Future<List<StoreDTO>> getListStore(
      String merchantId, String fromDate, String toDate, int offset) async {
    List<StoreDTO> result = [];

    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}merchant/statistic?userId=$userId&merchantId=$merchantId'
          '&fromDate=$fromDate&toDate=$toDate&offset=$offset';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<StoreDTO>((json) {
            return StoreDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<List<MerchantDTO>> getListMerchant() async {
    List<MerchantDTO> result = [];

    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}merchant-list/$userId';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<MerchantDTO>((json) {
            return MerchantDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<TotalStoreDTO> getTotalStoreByDay(
      String merchantId, String fromDate, String toDate) async {
    TotalStoreDTO result = TotalStoreDTO();

    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}merchant/overview?userId=$userId&merchantId=$merchantId&fromDate=$fromDate&toDate=$toDate';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = TotalStoreDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> createStore(Map<String, dynamic> param) async {
    ResponseMessageDTO result = ResponseMessageDTO(status: '', message: '');
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
}
