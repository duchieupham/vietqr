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
import 'package:vierqr/models/qr_feed_popup_detail_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_feed_private_dto.dart';
import 'package:vierqr/models/qr_folder_detail_dto.dart';
import 'package:vierqr/models/response_message_dto.dart';
import 'package:vierqr/models/user_folder_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class QrFeedRepository extends BaseRepo {
  String get userId => SharePrefUtils.getProfile().userId;

  MetaDataDTO? privateMetadata;

  MetaDataDTO? folderMetadata;

  MetaDataDTO? userFolderMetadata;

  Future<QrFeedDetailDTO?> addCommend({
    required String qrWalletId,
    required String message,
    required int page,
    required int size,
  }) async {
    try {
      Map<String, dynamic> param = {};
      param['qrWalletId'] = qrWalletId;
      param['userId'] = userId;
      param['message'] = message;
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-comment/add?page=$page&size=$size';
      final response = await BaseAPIClient.postAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        body: param,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return QrFeedDetailDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

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
          '${getIt.get<AppConfig>().getBaseUrl}qr-wallets/details/$qrWalletId?userId=$userId&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        // queryParameters: {
        //   'qrWalletId': qrWalletId,
        // },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return QrFeedDetailDTO.fromJson(data);
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

  Future<bool> deleteFolder(
      {required String folderId, required int deleteItems}) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}delete-folder?folderId=$folderId&deleteItems=$deleteItems';

      //  final response = await BaseAPIClient.deleteAPI(
      //       url: url,
      //       type: AuthenticationType.SYSTEM,
      //     );
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<List<QrFeedPrivateDTO>> getQrFeedPrivate({
    required int type,
    String value = '',
    required int page,
    required int size,
  }) async {
    List<QrFeedPrivateDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-wallets/private?userId=$userId&value=$value&type=$type&page=$page&size=$size';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        privateMetadata = MetaDataDTO.fromJson(data['metadata']);
        if (data != null) {
          result = data['data'].map<QrFeedPrivateDTO>((json) {
            return QrFeedPrivateDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<QrFolderDetailDTO?> getQrFolderDetail({
    required int type,
    required String folderId,
    required String value,
  }) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-feed/folder-qrs?type=$type&folderId=$folderId&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return QrFolderDetailDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<bool> updateRoleUserFolder({
    required String folderId,
    required String userFolderId,
    required String role,
  }) async {
    try {
      Map<String, dynamic> param = {};
      param['folderId'] = folderId;
      param['userId'] = userFolderId;
      param['role'] = role;

      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-folder/update-user-role';
      final response = await BaseAPIClient.putAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );

      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool> removeUserFolder({
    required String folderId,
    required String userFolderId,
  }) async {
    try {
      Map<String, dynamic> param = {};
      param['folderId'] = folderId;
      param['userId'] = userFolderId;
      String url = '${getIt.get<AppConfig>().getBaseUrl}qr-folder/remove-user';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: param,
        type: AuthenticationType.SYSTEM,
      );

      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<List<UserFolder>> getUserFolder({
    required String folderId,
    required String value,
    required int page,
    required int size,
  }) async {
    List<UserFolder> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-folder/user-roles/$folderId?value=$value&page=$page&size=$size';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        userFolderMetadata = MetaDataDTO.fromJson(data['metadata']);
        if (data != null) {
          result = data['data'].map<UserFolder>((json) {
            return UserFolder.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<List<QrFeedFolderDTO>> getQrFeedFolder({
    required int type,
    required String value,
    required int page,
    required int size,
  }) async {
    List<QrFeedFolderDTO> result = [];
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-feed/folders?userId=$userId&page=$page&size=$size&type=$type&value=$value';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        folderMetadata = MetaDataDTO.fromJson(data['metadata']);
        if (data != null) {
          result = data['data'].map<QrFeedFolderDTO>((json) {
            return QrFeedFolderDTO.fromJson(json);
          }).toList();
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<QrFeedPopupDetailDTO?> getQrFeedPopupDetail(
      {required String qrWalletId}) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/$qrWalletId/data';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
        // queryParameters: {
        //   'qrWalletId': qrWalletId,
        // },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return QrFeedPopupDetailDTO.fromJson(data);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<QrFeedDTO?> interactWithQr(
      {String? qrWalletId, String? interactionType}) async {
    // ResponseMessageDTO result =
    //     const ResponseMessageDTO(status: '', message: '');

    try {
      String url =
          "${getIt.get<AppConfig>().getBaseUrl}qr-interaction/interact";
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
