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
import 'package:vierqr/features/qr_feed/views/qr_screen.dart';
import 'package:vierqr/models/create_folder_dto.dart';
import 'package:vierqr/models/metadata_dto.dart';
import 'package:vierqr/models/qr_create_type_dto.dart';
import 'package:vierqr/models/qr_feed_detail_dto.dart';
import 'package:vierqr/models/qr_feed_popup_detail_dto.dart';
import 'package:vierqr/models/qr_feed_dto.dart';
import 'package:vierqr/models/qr_feed_folder_dto.dart';
import 'package:vierqr/models/qr_feed_private_dto.dart';
import 'package:vierqr/models/qr_folder_detail_dto.dart';
import 'package:vierqr/models/qr_folder_dto.dart';
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

  Future<bool> updateFolderTitle(
      {required String id,
      required String title,
      required String description}) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-feed/update-folder?id=$id';
      Map<String, dynamic> param = {};
      param['title'] = title;
      param['description'] = description;
      final response = await BaseAPIClient.putAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool> removeQRFolder(dynamic data) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-feed/delete-qrs-folder';

      final response = await BaseAPIClient.deleteAPI(
        body: data,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool> updateQRFolder(dynamic data) async {
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}qr-feed/add-qr-folder';

      final response = await BaseAPIClient.postAPI(
        body: data,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<QRFolderDTO?> getQRFolder({
    required String folderId,
    required int page,
    required int size,
    int? addedToFolder,
  }) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-feed/folder-wallets?folderId=$folderId&userId=$userId&addedToFolder=${addedToFolder ?? ''}&page=$page&size=$size';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return QRFolderDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
  }

  Future<bool> updateQr(dynamic data, TypeQr type) async {
    try {
      String url = '';
      switch (type) {
        case TypeQr.OTHER:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/update-qr-link?type=1';
          break;
        case TypeQr.QR_LINK:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/update-qr-link?type=0';
          break;
        case TypeQr.VCARD:
          url = '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/update-qr-vcard';
          break;
        case TypeQr.VIETQR:
          url =
              '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/update-qr-vietqr';
          break;
        default:
      }
      final response = await BaseAPIClient.putAPI(
        body: data,
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
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

  Future<bool> addUserFolder({
    required String folderId,
    required List<UserFolder> userRoles,
  }) async {
    try {
      List<Map<String, dynamic>> userRolesToJson(List<UserFolder> userRoles) {
        return userRoles
            .map((userFolder) => userFolder.toUpdateJson())
            .toList();
      }

      Map<String, dynamic> param = {};
      param['folderId'] = folderId;
      param['userId'] = userId;
      param['userRoles'] = userRolesToJson(userRoles);

      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-feed/add-user-folder';

      final response = await BaseAPIClient.postAPI(
        body: param,
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }

    return false;
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

  Future<ResponseMessageDTO> deleteFolder(
      {required String folderId, required int deleteItems}) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}delete-folder?folderId=$folderId&deleteItems=$deleteItems';
      final Map<String, dynamic> body = {};
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: jsonEncode(body),
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
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

  Future<bool> createFolder(CreateFolderDTO dto) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-feed/generate-folder';

      final response = await BaseAPIClient.postAPI(
        body: dto.toJson(),
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<AllUserFolder?> getAllUserFolder({
    required String folderId,
    required int page,
    required int size,
  }) async {
    try {
      String url =
          '${getIt.get<AppConfig>().getBaseUrl}qr-folder/user-roles/$folderId?value=&page=$page&size=$size';

      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return AllUserFolder.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return null;
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

  Future<ResponseMessageDTO> deleteQrCodes(List<String> qrIds) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${getIt.get<AppConfig>().getBaseUrl}qr-wallet/delete-qr';
      final response = await BaseAPIClient.deleteAPI(
        url: url,
        body: {'qrIds': qrIds},
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      }
      //  else {
      //    result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      // }
    } catch (e) {
      LOG.error(e.toString());
      // result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
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
