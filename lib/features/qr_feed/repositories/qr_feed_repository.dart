import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QrFeedRepository extends BaseRepo {
  String get userId => SharePrefUtils.getProfile().userId;

  Future<List<QrFeedDTO>> getQrFeed(
      {int page = 1, int size = 20, required int type}) async {
    List<QrFeedDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-wallet?page=$page&size=$size&type=$type&value=';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          metaDataDTO = MetaDataDTO.fromJson(data['metadata']);
          result = data['data'].map<QrFeedDTO>((json) {
            return QrFeedDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
