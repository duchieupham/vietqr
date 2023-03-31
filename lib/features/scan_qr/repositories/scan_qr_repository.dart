import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/bank_type_dto.dart';

class ScanQrRepository {
  const ScanQrRepository();

  Future<BankTypeDTO> getBankTypeByCaiValue(String caiValue) async {
    BankTypeDTO result = const BankTypeDTO(
      id: '',
      bankCode: '',
      bankName: '',
      imageId: '',
      status: 0,
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}bank-type/cai/$caiValue';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = BankTypeDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
