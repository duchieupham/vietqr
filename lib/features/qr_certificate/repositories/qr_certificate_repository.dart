import 'dart:convert';
import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/ecommerce_request_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';

class QrCertificateRepository {
  QrCertificateRepository();

  Future<ResponseMessageDTO> ecomActive(EcommerceRequest ecom) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(message: '', status: '');

    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}ecommerce/active';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: ecom.toJson(),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
        if (result.message == 'E163') {
          result = const ResponseMessageDTO(status: 'FAILED', message: 'E163');
        } else {
          result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
        }
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }

    return result;
  }

  Future<dynamic> scanEcommerceCode(String ecommerceCode) async {
    // ResponseMessageDTO result =
    //     const ResponseMessageDTO(message: '', status: '');
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}ecommerce/active?ecommerceCode=$ecommerceCode';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final result = EcommerceRequest.fromJson(data);
        return result;
      } else {
        var data = jsonDecode(response.body);
        final result = ResponseMessageDTO.fromJson(data);
        return result;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
