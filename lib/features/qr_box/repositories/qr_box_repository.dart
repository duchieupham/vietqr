import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/active_qr_box_dto.dart';
import 'package:vierqr/models/store/merchant_dto.dart';
import 'package:vierqr/models/terminal_qr_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../commons/utils/base_api.dart';

class QRBoxRepository {
  String get userId => SharePrefUtils.getProfile().userId.trim();

  Future<ActiveQRBoxDTO?> activeQRBox(
      {required String cert,
      required String terminalId,
      required String bankId}) async {
    try {
      Map<String, dynamic> param = {};
      param['qrCertificate'] = cert;
      param['terminalId'] = terminalId;
      param['bankId'] = bankId;
      param['userId'] = userId;

      String url = '${EnvConfig.getBaseUrl()}tid/active-box';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return ActiveQRBoxDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<List<MerchantDTO>> getListMerchant(String bankId) async {
    List<MerchantDTO> result = [];

    try {
      String url =
          '${EnvConfig.getBaseUrl()}merchant-form/$userId?bankId=$bankId';
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

  Future<List<TerminalQRDTO>> getTerminals(
      {required String merchantId, required String bankId}) async {
    List<TerminalQRDTO> listTerminal = [];

    try {
      String url =
          '${EnvConfig.getBaseUrl()}terminal/$merchantId?userId=$userId&bankId=$bankId';
      final response =
          await BaseAPIClient.getAPI(url: url, type: AuthenticationType.SYSTEM);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          listTerminal = data
              .map<TerminalQRDTO>((json) => TerminalQRDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return listTerminal;
  }
}
