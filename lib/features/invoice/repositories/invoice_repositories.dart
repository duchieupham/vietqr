import 'dart:convert';

import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/bank_account_dto.dart';

import '../../../commons/constants/env/env_config.dart';
import '../../../commons/enums/authentication_type.dart';
import '../../../commons/utils/base_api.dart';
import '../../../commons/utils/log.dart';
import '../../../models/invoice_detail_dto.dart';
import '../../../models/invoice_fee_dto.dart';
import '../../../models/metadata_dto.dart';
import '../../../services/local_storage/shared_preference/shared_pref_utils.dart';

class InvoiceRepository extends BaseRepo {
  Future<List<InvoiceFeeDTO>?> getInvoiceList(
      {int? status,
      String? bankId,
      int? filterBy,
      String? time,
      int? page,
      int? size}) async {
    List<InvoiceFeeDTO>? result = [];

    try {
      //  final String url = '${EnvConfig.getBaseUrl()}key-active-bank/annual-fee';
      String userId = SharePrefUtils.getProfile().userId.trim();
      final String url =
          '${EnvConfig.getBaseUrl()}invoice/$userId?filterBy=$filterBy&time=${time ?? ''}&page=$page&size=${size ?? 20}&bankId=$bankId&status=$status';

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
        metaDataDTO = MetaDataDTO.fromJson(data["metadata"]);
        return result = data['data'].map<InvoiceFeeDTO>((json) {
          return InvoiceFeeDTO.fromJson(json);
        }).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<InvoiceDetailDTO?> getInvoiceDetail({
    required String invoiceId,
  }) async {
    InvoiceDetailDTO? result;
    try {
      final String url =
          'https://dev.vietqr.org/vqr/api/invoice-detail/$invoiceId';
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
        return InvoiceDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
