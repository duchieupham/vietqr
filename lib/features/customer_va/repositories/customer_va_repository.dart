import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/customer_va_confirm_dto.dart';
import 'package:vierqr/models/customer_va_item_dto.dart';
import 'package:vierqr/models/customer_va_request_dto.dart';
import 'package:vierqr/models/customer_va_response_otp_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class CustomerVaRepository {
  const CustomerVaRepository();

//check existed
  Future<ResponseMessageDTO> checkExistedBankAccountVa(
      String bankAccount, String bankCode) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}customer-va/check-existed?bankAccount=$bankAccount&bankCode=$bankCode';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error('checkExistedBankAccountVa: ERROR: ' + e.toString());
    }
    return result;
  }

  //get list
  Future<List<CustomerVAItemDTO>> getCustomerVasByUserId(String userId) async {
    List<CustomerVAItemDTO> result = [];
    try {
      final String url =
          '${EnvConfig.getBaseUrl()}customer-va/list?userId=$userId';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<CustomerVAItemDTO>(
                  (json) => CustomerVAItemDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error('getCustomerVasByUserId: ERROR: ' + e.toString());
    }
    return result;
  }

//request va
  Future<dynamic> requestCustomerVaOTP(CustomerVaRequestDTO dto) async {
    dynamic result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    try {
      String url = '${EnvConfig.getBaseUrl()}customer-va/request';
      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.SYSTEM, body: dto.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        if (data != null && response.statusCode == 400) {
          result = ResponseMessageDTO.fromJson(data);
        } else if (data != null && response.statusCode == 200) {
          result = ResponseObjectDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

//confirm va
  Future<ResponseMessageDTO> confirmCustomerVaOTP(
      CustomerVaConfirmDTO dto) async {
    dynamic result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    try {
      String url = '${EnvConfig.getBaseUrl()}customer-va/confirm';
      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.SYSTEM, body: dto.toJson());
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('confirmCustomerVaOTP: ' + e.toString());
    }
    return result;
  }

//unregister va
  Future<ResponseMessageDTO> unRegisterCustomerVa(
      String merchantId, String userId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    try {
      String url =
          '${EnvConfig.getBaseUrl()}customer-va/unregister?userId=$userId&merchantId=$merchantId';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: {},
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('unRegisterCustomerVa: ERROR: ' + e.toString());
    }
    return result;
  }

//insert va
  Future<ResponseMessageDTO> insertCustomerVa(body) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    try {
      String url = '${EnvConfig.getBaseUrl()}customer-va/insert';
      final response = await BaseAPIClient.postAPI(
          url: url, type: AuthenticationType.SYSTEM, body: body);
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = ResponseMessageDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error('insertCustomerVa: ERROR:' + e.toString());
    }
    return result;
  }
}
