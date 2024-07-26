import 'dart:convert';

import 'package:vierqr/commons/constants/configurations/stringify.dart';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/invoice_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class OrderMerchantRepository {
  const OrderMerchantRepository();

  //get detail
  Future<ResponseMessageDTO> createOrder(body) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');

    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}customer-va/invoice/create';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: body,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(
            status: Stringify.RESPONSE_STATUS_FAILED, message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<InvoiceDTO>> getListOrder(String customerId, int offset) async {
    List<InvoiceDTO> result = [];
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}customer-va/invoice/list?customerId=$customerId&offset=$offset';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result =
            data.map<InvoiceDTO>((json) => InvoiceDTO.fromJson(json)).toList();
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<InvoiceDTO> getDetailOrder(String billId) async {
    InvoiceDTO result = InvoiceDTO();
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}customer-va/invoice/detail?billId=$billId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = InvoiceDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> removeOrder(String billId) async {
    ResponseMessageDTO result = const ResponseMessageDTO(status: '', message: '');
    try {
      final String url =
          '${getIt.get<AppConfig>().getBaseUrl}customer-va/invoice/remove?billId=$billId';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(
            status: Stringify.RESPONSE_STATUS_FAILED, message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(
          status: Stringify.RESPONSE_STATUS_FAILED, message: 'E05');
    }
    return result;
  }
}
