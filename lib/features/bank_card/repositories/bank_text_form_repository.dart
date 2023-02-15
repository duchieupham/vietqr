import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/bank_text_form_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class BankTextFormRepository {
  const BankTextFormRepository();

  Future<ResponseMessageDTO> insertBankTextForm(
      String text, String bankId) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-text-form';
      final Map<String, dynamic> data = {};
      data['text'] = text;
      data['bank_id'] = bankId;
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E10');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E10');
    }
    return result;
  }

  Future<List<BankTextFormDTO>> getBankTextForms(String bankId) async {
    List<BankTextFormDTO> result = [];
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-text-form/$bankId';
      final response = await BaseAPIClient.getAPI(url: url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data
              .map<BankTextFormDTO>((json) => BankTextFormDTO.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<ResponseMessageDTO> removeBankTextForm(String id) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-text-form';
      final Map<String, dynamic> data = {};
      data['id'] = id;
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: data,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E11');
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
