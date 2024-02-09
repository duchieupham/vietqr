import 'dart:convert';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/statistical_dto.dart';

class StatisticRepository {
  const StatisticRepository();

  Future<ResponseStatisticDTO> getDataOverview({
    required String terminalCode,
    required String bankId,
    required String month,
    required String userId,
  }) async {
    ResponseStatisticDTO result = ResponseStatisticDTO();
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transaction/overview/$bankId?terminalCode=$terminalCode&month=$month&userId=$userId';
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

  Future<List<ResponseStatisticDTO>> getDataTable({
    required String terminalCode,
    required String bankId,
    required String month,
    required String userId,
  }) async {
    List<ResponseStatisticDTO> list = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}transaction/statistic?terminalCode=$terminalCode&bankId=$bankId&month=$month&userId=$userId';
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
