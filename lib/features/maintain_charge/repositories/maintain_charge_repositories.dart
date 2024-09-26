import 'dart:async';
import 'dart:convert';

import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/models/maintain_charge_create.dart';

import '../../../commons/constants/env/env_config.dart';
import '../../../commons/enums/authentication_type.dart';
import '../../../commons/utils/base_api.dart';
import '../../../commons/utils/log.dart';
import '../../../models/annual_fee_dto.dart';
import '../../../models/confirm_manitain_charge_dto.dart';
import '../../../models/maintain_charge_dto.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';

class MaintainChargeRepositories {
  const MaintainChargeRepositories();

  Future<ActiveAnnualStatus?> activeAnnual(
      {required int? type,
      required String? feeId,
      required String? bankId,
      required String? userId,
      required String password}) async {
    try {
      Map map = {
        'type': type,
        'feeId': feeId,
        'bankId': bankId,
        'userId': userId,
        'password': password,
      };
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-active-bank/request-active';
      final String token = await SharePrefUtils.getTokenInfo();
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: map,
        type: AuthenticationType.SYSTEM,
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ActiveAnnualStatus(
          statusCode: response.statusCode,
          code: "SUCCESS",
          message: "",
          res: AnnualFeeActiveRes.fromJson(data),
        );
      } else {
        return ActiveAnnualStatus.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      return ActiveAnnualStatus(
        statusCode: 404,
        code: "FAILED",
        message: "",
        res: null,
      );
    }
  }

  Future<ActiveAnnualStatus?> confirmActiveAnnual({
    required String? otp,
    required String? bankId,
    required String? userId,
    required String? password,
    required String? request,
    required String? otpPayment,
    required String? feeId,
  }) async {
    try {
      Map map = {
        'otp': otp,
        'bankId': bankId,
        'userId': userId,
        'password': password,
        'request': request,
        'paymentMethod': 1,
        'otpPayment': otpPayment,
        'feeId': feeId,
      };
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-active-bank/confirm-active';
      final String token = await SharePrefUtils.getTokenInfo();
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: map,
        type: AuthenticationType.SYSTEM,
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ActiveAnnualStatus(
          statusCode: response.statusCode,
          code: "SUCCESS",
          message: "",
          // res: AnnualFeeActiveRes.fromJson(data),
          confirm: AnnualFeeConfirm.fromJson(data),
        );
      } else {
        return ActiveAnnualStatus.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      return ActiveAnnualStatus(
        statusCode: 404,
        code: "FAILED",
        message: "",
        res: null,
      );
    }
  }

  Future<List<AnnualFeeDTO>?> getAnnualFeeList(String bankId) async {
    List<AnnualFeeDTO>? result = [];
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}key-active-bank/annual-fee?bankId=$bankId';
      final String token = await SharePrefUtils.getTokenInfo();
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        header: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<AnnualFeeDTO>((json) {
            return AnnualFeeDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<MaintainChargeStatus?> chargeMaintainace(
      MaintainChargeCreate dto) async {
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}request-active-key/backup';
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
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}confirm-active-key';
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
