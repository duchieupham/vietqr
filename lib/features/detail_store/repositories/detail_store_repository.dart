import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/store/detail_store_dto.dart';
import 'package:vierqr/models/store/member_store_dto.dart';
import 'package:vierqr/models/store/trans_store_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class DetailStoreRepository {
  DetailStoreRepository();

  String get userId => SharePrefUtils.getProfile().userId;

  Future<TransStoreDTO> getTransStore(
      String terminalCode,
      String subTerminalCode,
      String value,
      String fromDate,
      String toDate,
      int type,
      int page) async {
    TransStoreDTO result = TransStoreDTO();

    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}transactions/sub-terminal/$terminalCode'
          '?userId=$userId&subTerminalCode=$subTerminalCode&page=$page&size=20'
          '&value=$value&fromDate=$fromDate&toDate=$toDate&type=$type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = TransStoreDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<DetailStoreDTO> getDetailQR(String terminalId) async {
    DetailStoreDTO result = DetailStoreDTO();

    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/detail-qr/$terminalId?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = DetailStoreDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<DetailStoreDTO> getDetailStore(
      String terminalId, String fromDate, String toDate) async {
    DetailStoreDTO result = DetailStoreDTO();

    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/sub-detail/$terminalId?fromDate=$fromDate&toDate=$toDate';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = DetailStoreDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<ResponseMessageDTO> addMemberGroup(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${getIt.get<AppConfig>().getBaseUrl}terminal-member';
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

  Future<List<MemberStoreDTO>> getMembersStore(String terminalId) async {
    List<MemberStoreDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/member-detail/$terminalId?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<MemberStoreDTO>((json) {
            return MemberStoreDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<List<SubTerminal>> getTerminalStore(String terminalId) async {
    List<SubTerminal> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal/list-sub-terminal/$terminalId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<SubTerminal>((json) {
            return SubTerminal.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return result;
    }
    return result;
  }

  Future<ResponseMessageDTO> removeMember(Map<String, dynamic> param) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}terminal-member/remove';
      final response = await BaseAPIClient.deleteAPI(
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
