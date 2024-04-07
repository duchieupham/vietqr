import 'dart:convert';

import 'package:vierqr/models/maintain_charge_create.dart';
import 'package:http/http.dart' as http;

import '../../../commons/constants/env/env_config.dart';
import '../../../commons/enums/authentication_type.dart';
import '../../../commons/utils/base_api.dart';
import '../../../commons/utils/log.dart';
import '../../../models/confirm_manitain_charge_dto.dart';
import '../../../models/maintain_charge_dto.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';

class MaintainChargeRepositories {
  const MaintainChargeRepositories();

  Future<MaintainChargeStatus?> chargeMaintainace(
      MaintainChargeCreate dto) async {
    try {
      final String url = '${EnvConfig.getBaseUrl()}request-active-key';
      final String token = await SharePrefUtils.getTokenInfo();
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return MaintainChargeStatus(
          statusCode: response.statusCode,
          code: "SUCCESS",
          message: "",
          dto: MaintainChargeDTO.fromJson(data),
        );
      } else {
        return MaintainChargeStatus.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      return MaintainChargeStatus(
        statusCode: 404,
        code: "FAILED",
        message: "",
        dto: null,
      );
    }
  }

  Future<bool?> confirmMaintainCharge(ConfirmMaintainCharge dto) async {
    try {
      final String url = '${EnvConfig.getBaseUrl()}confirm-active-key';
      final String token = await SharePrefUtils.getTokenInfo();
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.SYSTEM,
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
      return false;
    }
  }
}
