import 'dart:convert';

import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/unpaid_invoice_detail_qr_dto.dart';

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
      //  final String url = '${getIt.get<AppConfig>().getBaseUrl}key-active-bank/annual-fee';
      String userId = SharePrefUtils.getProfile().userId.trim();
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}invoice/$userId?filterBy=$filterBy&time=${time ?? ''}&page=$page&size=${size ?? 20}&bankId=$bankId&status=$status';

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

  Future<UnpaidInvoiceDetailQrDTO?> requestPaymnetV2({
    required List<String> invoiceIds,
    String bankIdRecharge = '',
  }) async {
    try {
      Map<String, dynamic> param = {};
      param['invoiceIds'] = invoiceIds;
      param['bankIdRecharge'] = bankIdRecharge;

      String url =
          '${getIt.get<AppConfig>().getBaseUrl}invoice/request-payment/v2';
      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return UnpaidInvoiceDetailQrDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error("Failed to request payment: ${e.toString()}");
      rethrow;
    }
  }

  Future<InvoiceDetailDTO?> getInvoiceDetail({
    required String invoiceId,
  }) async {
    InvoiceDetailDTO? result;
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}invoice-detail/$invoiceId';
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
