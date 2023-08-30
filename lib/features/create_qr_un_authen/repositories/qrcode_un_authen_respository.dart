import 'dart:convert';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/qr_generated_dto.dart';

class QRCodeUnUTRepository {
  const QRCodeUnUTRepository();

  Future<QRGeneratedDTO> generateQR(Map<String, dynamic> data) async {
    QRGeneratedDTO result = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '',
    );
    try {
      final String url = '${EnvConfig.getBaseUrl()}qr/generate/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = QRGeneratedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<QRGeneratedDTO> generateQRStaging(Map<String, dynamic> data) async {
    QRGeneratedDTO result = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '',
    );
    try {
      const String url =
          'http://112.78.1.220:8084/vqr/api/qr/generate/unauthenticated';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: data,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = QRGeneratedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
