import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:vierqr/commons/constants/env/env_config.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/authentication_type.dart';
import 'package:vierqr/commons/utils/base_api.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/features/invoice/repositories/base_repository.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/models/qr_feed_detail_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QrFeedRepository extends BaseRepo {
  String get userId => SharePrefUtils.getProfile().userId;

  Future<ResponseMessageDTO> createQrLink(
      {required QrCreateFeedDTO dto, File? file}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      // String url =
      //     '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/generate-qr?type=${dto.type}&json=${jsonEncode(data['json'])}';
      String url = '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/generate-qr';
      final List<http.MultipartFile> files = [];
      MultipartFile imageFile;
      if (file != null) {
        imageFile = await http.MultipartFile.fromPath('file', file.path);
        // files.add(imageFile);
      } else {
        imageFile = http.MultipartFile.fromBytes(
            'file', Uint8List.fromList([0]),
            filename: '');
      }
      files.add(imageFile);

      final response = await BaseAPIClient.postMultipartAPI(
          url: url, fields: dto.toJson(), files: files);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<QrFeedDetailDTO?> getDetailQrFeed(
      {required int page,
      required int size,
      required String qrWalletId}) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-wallets/public/details?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
          url: url,
          type: AuthenticationType.SYSTEM,
          queryParameters: {
            'qrWalletId': qrWalletId,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          metaDataDTO = MetaDataDTO.fromJson(data['comments']['metadata']);
          return QrFeedDetailDTO.fromJson(data['comments']['data']);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<List<QrFeedDTO>> getQrFeed(
      {required int page, required int size, required int type}) async {
    List<QrFeedDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-wallets/public?userId=$userId&page=$page&size=$size&type=$type';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          metaDataDTO = MetaDataDTO.fromJson(data['metadata']);
          result = data['data'].map<QrFeedDTO>((json) {
            return QrFeedDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<QrFeedDTO?> interactWithQr(
      {String? qrWalletId, String? interactionType}) async {
    // ResponseMessageDTO result =
    //     const ResponseMessageDTO(status: '', message: '');

    try {
      final String url =
          "https://dev.vietqr.org/vqr/api/qr-interaction/interact";
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {
          'qrWalletId': qrWalletId,
          "userId": userId,
          'interactionType': interactionType,
        },
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return QrFeedDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      // result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return null;
  }
}
