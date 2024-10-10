import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/vietqr_store_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class VietqQRStoreRepository extends BaseRepo {
  String get userId => SharePrefUtils.getProfile().userId;

  Future<List<VietQRStoreDTO>> getListStore(
      {required String bankId, required int page, required int size}) async {
    List<VietQRStoreDTO> list = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/v2?userId=$userId&page=$page&size=$size&bankId=$bankId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metaDataDTO = MetaDataDTO.fromJson(data['metadata']);
        list = data['data']
            .map<VietQRStoreDTO>((json) => VietQRStoreDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return list;
  }
}
