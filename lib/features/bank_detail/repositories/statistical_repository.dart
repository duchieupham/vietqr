import 'dart:convert';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/time_utils.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/respone_top_up_dto.dart';
import 'package:vierqr/models/statistical_dto.dart';

class StatisticRepository {
  const StatisticRepository();

  Future<ResponseStatisticDTO> getDataOverview(String bankId) async {
    ResponseStatisticDTO result = const ResponseStatisticDTO();
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transaction/overview/$bankId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseStatisticDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<ResponseStatisticDTO>> getDataTable(
      {required String bankId, required int type}) async {
    List<ResponseStatisticDTO> list = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transaction/statistic?bankId=$bankId&type=$type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        list = data
            .map<ResponseStatisticDTO>(
                (json) => ResponseStatisticDTO.fromJson(json))
            .toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return list;
  }
}
